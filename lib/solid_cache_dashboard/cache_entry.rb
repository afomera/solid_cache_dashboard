module SolidCacheDashboard
  module CacheEntry
    # Constants
    ACTIVE = :active
    EXPIRED = :expired
    
    STATUSES = [ACTIVE, EXPIRED]
    
    STATUS_COLORS = {
      ACTIVE => "green",
      EXPIRED => "amber"
    }
    
    def self.status_color(status)
      STATUS_COLORS[status] || "zinc"
    end
  end
end
