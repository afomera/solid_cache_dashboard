# frozen_string_literal: true

require "rails"
require "groupdate"
require "chartkick"
require_relative "solid_cache_dashboard/version"
require_relative "solid_cache_dashboard/configuration"
require_relative "solid_cache_dashboard/engine"
require_relative "solid_cache_dashboard/cache_entry"
# require_relative "solid_cache_dashboard/cache_event"
require_relative "solid_cache_dashboard/instrumentation"
require_relative "solid_cache_dashboard/models/cache_event"
require_relative "solid_cache_dashboard/decorators/cache_entry_decorator"
require_relative "solid_cache_dashboard/decorators/cache_entries_decorator"
require_relative "solid_cache_dashboard/decorators/cache_event_decorator"
require_relative "solid_cache_dashboard/decorators/cache_events_decorator"

module SolidCacheDashboard
  class Error < StandardError; end

  # Pagy version detection - single source of truth for API compatibility
  def self.pagy_43_or_newer?
    @pagy_43_or_newer ||= Gem::Version.new(Pagy::VERSION) >= Gem::Version.new("43.0.0")
  end

  # Pagy 9+ uses `limit:` instead of `items:` for per-page count
  def self.pagy_uses_limit?
    @pagy_uses_limit ||= Gem::Version.new(Pagy::VERSION) >= Gem::Version.new("9.0.0")
  end

  # Helper to get series from pagy object (Pagy 6–9 only, where series is public)
  def self.pagy_series(pagy)
    pagy.series
  end

  def self.cache_keys
    SolidCache::Entry.pluck(:key_hash).uniq
  end

  def self.decorate(object)
    case object
    when SolidCache::Entry
      Decorators::CacheEntryDecorator.new(object)
    when SolidCache::Entry.const_get(:ActiveRecord_Relation)
      Decorators::CacheEntriesDecorator.new(object)
    when SolidCacheDashboard::CacheEvent
      Decorators::CacheEventDecorator.new(object)
    when SolidCacheDashboard::CacheEvent.const_get(:ActiveRecord_Relation)
      Decorators::CacheEventsDecorator.new(object)
    else
      raise Error, "Cannot decorate #{object.class}"
    end
  end
end
