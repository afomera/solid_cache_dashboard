# frozen_string_literal: true

require "active_support/notifications"

module SolidCacheDashboard
  module Instrumentation
    def self.install
      ActiveSupport::Notifications.subscribe("cache_read.active_support") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        key = event.payload[:key].to_s
        key_hash = calculate_key_hash(key)
        hit = event.payload[:hit]
        
        SolidCacheDashboard::CacheEvent.create!(
          event_type: hit ? SolidCacheDashboard::CacheEvent::HIT : SolidCacheDashboard::CacheEvent::MISS,
          key_hash: key_hash,
          key_string: key.truncate(100),
          duration: event.duration / 1000.0, # Convert from ms to seconds
          created_at: Time.current
        )
      end

      ActiveSupport::Notifications.subscribe("cache_write.active_support") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        key = event.payload[:key].to_s
        key_hash = calculate_key_hash(key)

        entry_size = nil
        if event.payload[:entry]
          entry_size = event.payload[:entry].bytesize
        end
        
        SolidCacheDashboard::CacheEvent.create!(
          event_type: SolidCacheDashboard::CacheEvent::WRITE,
          key_hash: key_hash,
          key_string: key.truncate(100),
          byte_size: entry_size,
          duration: event.duration / 1000.0, # Convert from ms to seconds
          created_at: Time.current
        )
      end

      ActiveSupport::Notifications.subscribe("cache_delete.active_support") do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        key = event.payload[:key].to_s
        key_hash = calculate_key_hash(key)
        
        SolidCacheDashboard::CacheEvent.create!(
          event_type: SolidCacheDashboard::CacheEvent::DELETE,
          key_hash: key_hash,
          key_string: key.truncate(100),
          duration: event.duration / 1000.0, # Convert from ms to seconds
          created_at: Time.current
        )
      end
    end
    
    # Calculate the key hash in the same way SolidCache::Entry does
    def self.calculate_key_hash(key)
      require 'digest'
      
      # Need to unpack this as a signed integer - Same method used in SolidCache::Entry
      # See: Digest::SHA256.digest(key.to_s).unpack("q>").first
      Digest::SHA256.digest(key.to_s).unpack("q>").first
    end
  end
end
