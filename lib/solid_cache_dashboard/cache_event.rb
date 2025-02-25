module SolidCacheDashboard
  module CacheEvent
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
  end
end
