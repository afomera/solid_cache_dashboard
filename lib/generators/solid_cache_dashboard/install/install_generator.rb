module SolidCacheDashboard
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_migrations
        template "create_solid_cache_dashboard_events.rb", "db/migrate/#{timestamp}_create_solid_cache_dashboard_events.rb"
      end

      private

      def timestamp
        Time.current.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
