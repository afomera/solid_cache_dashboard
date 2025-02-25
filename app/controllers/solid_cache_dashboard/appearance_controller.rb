module SolidCacheDashboard
  class AppearanceController < ApplicationController
    def toggle
      cookies[:solid_cache_dashboard_dark_mode] = dark_mode? ? "false" : "true"
      
      redirect_back(fallback_location: root_path)
    end
  end
end
