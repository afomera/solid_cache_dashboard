module SolidCacheDashboard
  module Decorators
    class CacheEntriesDecorator
      include Enumerable

      delegate :current_page, :total_pages, :limit_value, :total_count, :offset_value, to: :@entries

      def initialize(entries)
        @entries = entries
      end

      def each(&block)
        @entries.each do |entry|
          block.call(SolidCacheDashboard.decorate(entry))
        end
      end

      def total_size
        @total_size ||= @entries.sum(:byte_size)
      end

      def human_total_size
        ActiveSupport::NumberHelper.number_to_human_size(total_size)
      end
    end
  end
end
