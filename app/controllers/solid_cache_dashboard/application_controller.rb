module SolidCacheDashboard
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    helper SolidCacheDashboard::ApplicationHelper

    def dark_mode?
      cookies[:solid_cache_dashboard_dark_mode] == "true"
    end
    helper_method :dark_mode?
  end
end
