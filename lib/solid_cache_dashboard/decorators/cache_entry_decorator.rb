module SolidCacheDashboard
  module Decorators
    class CacheEntryDecorator
      def initialize(entry)
        @entry = entry
      end

      def key_hash
        @entry.key_hash
      end

      def key
        @entry.key
      rescue
        key_hash
      end

      def value
        @value ||= @entry.value.to_s
      rescue
        "Binary data"
      end

      def byte_size
        @entry.byte_size
      end

      def human_byte_size
        ActiveSupport::NumberHelper.number_to_human_size(byte_size)
      end

      def created_at
        @entry.created_at
      end

      def created_at_ago
        time_ago_in_words(created_at, Time.now)
      end

      def status
        expires_at.present? && expires_at <= Time.now ? SolidCacheDashboard::CacheEntry::EXPIRED : SolidCacheDashboard::CacheEntry::ACTIVE
      end

      def status_badge
        status_text = status.to_s.capitalize
        color = SolidCacheDashboard::CacheEntry.status_color(status)
        
        "<span class='inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-#{color}-100 dark:bg-#{color}-800 text-#{color}-800 dark:text-#{color}-100'>#{status_text}</span>".html_safe
      end

      def expires_at
        return unless @entry.respond_to?(:expires_at)
        @entry.expires_at
      end

      def expires_in
        return unless expires_at
        
        if expires_at <= Time.now
          "Expired #{time_ago_in_words(expires_at, Time.now)}"
        else
          time_ago_in_words(Time.now, expires_at)
        end
      end

      def encrypted?
        return false unless defined?(SolidCache.configuration)
        SolidCache.configuration.encrypt?
      end

      def encryption_status
        encrypted? ? "Encrypted" : "Not encrypted"
      end

      def estimated_row_overhead
        if encrypted?
          SolidCache::Entry::ESTIMATED_ROW_OVERHEAD + SolidCache::Entry::ESTIMATED_ENCRYPTION_OVERHEAD
        else
          SolidCache::Entry::ESTIMATED_ROW_OVERHEAD
        end
      rescue NameError
        140 # fallback to default ESTIMATED_ROW_OVERHEAD
      end

      def key_size
        @entry.key.to_s.bytesize
      end

      def value_size
        @entry.value.to_s.bytesize
      end

      def overhead_size
        byte_size - key_size - value_size
      end

      def overhead_percentage
        return 0 if byte_size == 0
        (overhead_size.to_f / byte_size * 100).round(1)
      end
      
      def total_lifetime
        return nil unless expires_at && created_at
        
        distance_in_seconds = (expires_at - created_at).round
        
        case distance_in_seconds
        when 0..59
          "#{distance_in_seconds} seconds"
        when 60..3599
          "#{(distance_in_seconds / 60).round} minutes"
        when 3600..86399
          "#{(distance_in_seconds / 3600).round} hours"
        else
          "#{(distance_in_seconds / 86400).round} days"
        end
      end

      def time_ago_in_words(from_time, to_time = Time.now)
        distance_in_seconds = (to_time - from_time).abs.round
        suffix = to_time > from_time ? "ago" : "from now"
        
        time_words = case distance_in_seconds
        when 0..59
          "#{distance_in_seconds} seconds"
        when 60..3599
          "#{(distance_in_seconds / 60).round} minutes"
        when 3600..86399
          "#{(distance_in_seconds / 3600).round} hours"
        else
          "#{(distance_in_seconds / 86400).round} days"
        end
        
        "#{time_words} #{suffix}"
      end
      
      private
    end
  end
end
