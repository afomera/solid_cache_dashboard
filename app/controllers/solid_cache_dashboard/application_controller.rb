module SolidCacheDashboard
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    helper SolidCacheDashboard::ApplicationHelper

    def dark_mode?
      cookies[:solid_cache_dashboard_dark_mode] == "true"
    end
    helper_method :dark_mode?

    private

    # Pagy compatibility wrapper
    def pagy(collection, **options)
      per_page = options.delete(:items) || options.delete(:limit) || 25

      if SolidCacheDashboard.pagy_43_or_newer?
        super(:offset, collection, **options.merge(limit: per_page))
      elsif SolidCacheDashboard.pagy_uses_limit?
        super(collection, **options.merge(limit: per_page))
      else
        super(collection, **options.merge(items: per_page))
      end
    end
  end
end
