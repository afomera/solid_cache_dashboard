module SolidCacheDashboard
  class StatsController < ApplicationController
    def index
      @cache_entries = SolidCacheDashboard.decorate(SolidCache::Entry.all)
      @cache_entries_count = SolidCache::Entry.count
      @cache_entries_size = SolidCache::Entry.sum(:byte_size)
      @cache_entries_human_size = ActiveSupport::NumberHelper.number_to_human_size(@cache_entries_size)
      
      @cache_events = SolidCacheDashboard.decorate(SolidCacheDashboard::CacheEvent.all)
      @hit_count = SolidCacheDashboard::CacheEvent.hits.count
      @miss_count = SolidCacheDashboard::CacheEvent.misses.count
      @write_count = SolidCacheDashboard::CacheEvent.writes.count
      @delete_count = SolidCacheDashboard::CacheEvent.deletes.count
      
      @hit_ratio = @hit_count + @miss_count > 0 ? @hit_count.to_f / (@hit_count + @miss_count) : 0
      @hit_percentage = "#{(@hit_ratio * 100).round(2)}%"
    end
  end
end
