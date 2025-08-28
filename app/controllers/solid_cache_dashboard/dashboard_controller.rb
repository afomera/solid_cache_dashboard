module SolidCacheDashboard
  class DashboardController < ApplicationController
    def index
      @chart_period = params[:chart_period] || '30m'
      @period_start = Time.current - chart_period_duration[@chart_period]

      @cache_entries = SolidCacheDashboard.decorate(SolidCache::Entry.where(created_at: @period_start..))
      @cache_events = SolidCacheDashboard.decorate(SolidCacheDashboard::CacheEvent.where(created_at: @period_start..))
      load_charts
    end

    private

    def chart_period_duration
      {
        '15m' => 15.minutes,
        '30m' => 30.minutes,
        '1h' => 1.hour,
        '3h' => 3.hours,
        '6h' => 6.hours,
        '12h' => 12.hours,
        '1d' => 1.day,
        '3d' => 3.days,
        '1w' => 1.week
      }
    end

    def load_charts
      case @chart_period
      when '15m'
        n = 1
        last = 15
      when '30m'
        n = 1
        last = 30
      when '1h'
        n = 2
        last = 30
      when '3h'
        n = 6
        last = 30
      when '6h'
        n = 12
        last = 30
      when '12h'
        n = 20
        last = 36
      when '1d'
        n = 30
        last = 48
      when '3d'
        n = 90 # 1.5 hours
        last = 48
      when '1w'
        n = 180 # 3 hours
        last = 56
      else
        n = 1
        last = 30
      end

      @charts = [
        {
          name: 'Hits',
          data: SolidCacheDashboard::CacheEvent
            .where(created_at: @period_start..)
            .hits
            .group_by_minute(:created_at, last: last, n: n)
            .count,
          color: '#23C55E'
        },
        {
          name: 'Misses',
          data: SolidCacheDashboard::CacheEvent
            .where(created_at: @period_start..)
            .misses
            .group_by_minute(:created_at, last: last, n: n)
            .count,
          color: '#FBBF26'
        },
        {
          name: 'Writes',
          data: SolidCacheDashboard::CacheEvent
            .where(created_at: @period_start..)
            .writes
            .group_by_minute(:created_at, last: last, n: n)
            .count,
          color: '#38BDF8'
        },
        {
          name: 'Deletes',
          data: SolidCacheDashboard::CacheEvent
            .where(created_at: @period_start..)
            .deletes
            .group_by_minute(:created_at, last: last, n: n)
            .count,
          color: '#F04444'
        }
      ]
    end
  end
end
