module SolidCacheDashboard
  class CacheEvent < ActiveRecord::Base
    # Types of cache events
    HIT = :hit
    MISS = :miss
    WRITE = :write
    DELETE = :delete
    
    EVENT_TYPES = [HIT, MISS, WRITE, DELETE]
    
    EVENT_COLORS = {
      HIT => "green",
      MISS => "amber",
      WRITE => "sky",
      DELETE => "red"
    }
    
    def self.event_color(event_type)
      EVENT_COLORS[event_type] || "zinc"
    end

    self.table_name = 'solid_cache_dashboard_events'

    scope :hits, -> { where(event_type: SolidCacheDashboard::CacheEvent::HIT) }
    scope :misses, -> { where(event_type: SolidCacheDashboard::CacheEvent::MISS) }
    scope :writes, -> { where(event_type: SolidCacheDashboard::CacheEvent::WRITE) }
    scope :deletes, -> { where(event_type: SolidCacheDashboard::CacheEvent::DELETE) }
    
    scope :recent, -> { order(created_at: :desc) }

    def hit?
      event_type.to_sym == SolidCacheDashboard::CacheEvent::HIT
    end

    def miss?
      event_type.to_sym == SolidCacheDashboard::CacheEvent::MISS
    end

    def write?
      event_type.to_sym == SolidCacheDashboard::CacheEvent::WRITE
    end

    def delete?
      event_type.to_sym == SolidCacheDashboard::CacheEvent::DELETE
    end

    def color
      SolidCacheDashboard::CacheEvent.event_color(event_type.to_sym)
    end
  end
end
