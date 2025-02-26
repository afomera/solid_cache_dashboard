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
    
    # Returns the appropriate color for the given status
    def self.status_color(status)
      STATUS_COLORS[status] || "zinc"
    end
    
    # Calculates the expiration status for a cache entry
    def self.determine_expiration_status(entry)
      return ACTIVE unless entry.respond_to?(:expires_at) && entry.expires_at
      entry.expires_at <= Time.now ? EXPIRED : ACTIVE
    end
    
    # Returns size breakdown information for a given entry
    def self.size_breakdown(entry)
      {
        key_size: entry.key.to_s.bytesize,
        value_size: entry.value.to_s.bytesize,
        overhead_size: estimate_overhead(entry)
      }
    end
    
    # Estimates the overhead size of a cache entry based on the SolidCache::Entry constants
    def self.estimate_overhead(entry)
      if defined?(SolidCache.configuration) && SolidCache.configuration.respond_to?(:encrypt?) && SolidCache.configuration.encrypt?
        estimated_encryption_overhead = defined?(SolidCache::Entry::ESTIMATED_ENCRYPTION_OVERHEAD) ?
                                       SolidCache::Entry::ESTIMATED_ENCRYPTION_OVERHEAD :
                                       170
        estimated_row_overhead = defined?(SolidCache::Entry::ESTIMATED_ROW_OVERHEAD) ?
                               SolidCache::Entry::ESTIMATED_ROW_OVERHEAD :
                               140
        estimated_row_overhead + estimated_encryption_overhead
      else
        defined?(SolidCache::Entry::ESTIMATED_ROW_OVERHEAD) ?
        SolidCache::Entry::ESTIMATED_ROW_OVERHEAD :
        140
      end
    end
  end
end
