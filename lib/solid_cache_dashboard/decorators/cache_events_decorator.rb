module SolidCacheDashboard
  module Decorators
    class CacheEventsDecorator
      include Enumerable

      delegate :current_page, :total_pages, :limit_value, :total_count, :offset_value, to: :@events

      def initialize(events)
        @events = events
      end

      def each(&block)
        @events.each do |event|
          block.call(SolidCacheDashboard.decorate(event))
        end
      end

      def hit_count
        @hit_count ||= @events.hits.count
      end

      def miss_count
        @miss_count ||= @events.misses.count
      end

      def write_count
        @write_count ||= @events.writes.count
      end

      def delete_count
        @delete_count ||= @events.deletes.count
      end

      def hit_ratio
        return 0 if hit_count + miss_count == 0
        hit_count.to_f / (hit_count + miss_count)
      end

      def hit_percentage
        "#{(hit_ratio * 100).round(2)}%"
      end
    end
  end
end
