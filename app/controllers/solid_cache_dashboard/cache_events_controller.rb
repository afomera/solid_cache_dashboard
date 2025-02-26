module SolidCacheDashboard
  class CacheEventsController < ApplicationController
    def index
      events = SolidCacheDashboard::CacheEvent.order(created_at: :desc)
      
      # Filter by event type if specified
      if params[:event_type].present? && params[:event_type] != "all"
        events = events.where(event_type: params[:event_type])
      end
      
      @pagy, events = pagy(events, items: 25)
      @cache_events = SolidCacheDashboard.decorate(events)
    end
  end
end
