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
        readable_key = @entry.key.force_encoding("UTF-8")
        readable_key.match?(/^[-+\/=A-Za-z0-9]+$/) ? readable_key : key_hash
      rescue
        key_hash
      end

      def value
        @value ||= Marshal.load(@entry.value)
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
        time_ago_in_words(created_at)
      end

      private
      
      def time_ago_in_words(time)
        distance_in_seconds = (Time.now - time).round
        
        case distance_in_seconds
        when 0..59
          "#{distance_in_seconds} seconds ago"
        when 60..3599
          "#{(distance_in_seconds / 60).round} minutes ago"
        when 3600..86399
          "#{(distance_in_seconds / 3600).round} hours ago"
        else
          "#{(distance_in_seconds / 86400).round} days ago"
        end
      end
    end
  end
end
