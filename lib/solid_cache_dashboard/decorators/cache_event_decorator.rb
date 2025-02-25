module SolidCacheDashboard
  module Decorators
    class CacheEventDecorator
      def initialize(event)
        @event = event
      end

      def id
        @event.id
      end

      def event_type
        @event.event_type
      end

      def key_hash
        @event.key_hash
      end

      def key_string
        @event.key_string || @event.key_hash.to_s
      end

      def byte_size
        @event.byte_size
      end

      def human_byte_size
        return nil unless @event.byte_size
        ActiveSupport::NumberHelper.number_to_human_size(@event.byte_size)
      end

      def duration
        @event.duration
      end

      def human_duration
        return nil unless @event.duration
        "#{(@event.duration * 1000).round(2)} ms"
      end

      def created_at
        @event.created_at
      end

      def color
        @event.color
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
