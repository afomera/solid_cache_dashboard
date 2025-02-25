module SolidCacheDashboard
  class CacheEventsController < ApplicationController
    def index
      @cache_events = SolidCacheDashboard.decorate(
        SolidCacheDashboard::CacheEvent.order(created_at: :desc)#.page(params[:page]).per(25)
      )
    end
  end
end
