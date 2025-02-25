# frozen_string_literal: true

require "active_support/notifications"

module SolidCacheDashboard
  module Instrumentation
    def self.install
      ActiveSupport::Notifications.subscribe("cache_read.active_support") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        key_hash = event.payload[:key].hash
        key_string = event.payload[:key].to_s
        hit = event.payload[:hit]
        
        SolidCacheDashboard::CacheEvent.create!(
          event_type: hit ? SolidCacheDashboard::CacheEvent::HIT : SolidCacheDashboard::CacheEvent::MISS,
          key_hash: key_hash,
          key_string: key_string.truncate(100),
          duration: event.duration / 1000.0, # Convert from ms to seconds
          created_at: Time.current
        )
      end

      ActiveSupport::Notifications.subscribe("cache_write.active_support") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        key_hash = event.payload[:key].hash
        key_string = event.payload[:key].to_s

        entry_size = nil
        if event.payload[:entry]
          entry_size = event.payload[:entry].bytesize
        end
        
        SolidCacheDashboard::CacheEvent.create!(
          event_type: SolidCacheDashboard::CacheEvent::WRITE,
          key_hash: key_hash,
          key_string: key_string.truncate(100),
          byte_size: entry_size,
          duration: event.duration / 1000.0, # Convert from ms to seconds
          created_at: Time.current
        )
      end

      ActiveSupport::Notifications.subscribe("cache_delete.active_support") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        key_hash = event.payload[:key].hash
        key_string = event.payload[:key].to_s
        
        SolidCacheDashboard::CacheEvent.create!(
          event_type: SolidCacheDashboard::CacheEvent::DELETE,
          key_hash: key_hash,
          key_string: key_string.truncate(100),
          duration: event.duration / 1000.0, # Convert from ms to seconds
          created_at: Time.current
        )
      end
    end
  end
end
