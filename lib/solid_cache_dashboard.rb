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
