require 'pagy'

module SolidCacheDashboard
  class Engine < ::Rails::Engine
    isolate_namespace SolidCacheDashboard

    initializer "solid_cache_dashboard.assets.precompile" do |app|
      app.config.assets.precompile += %w[
        solid_cache_dashboard/alpine.js
        solid_cache_dashboard/application.js
        solid_cache_dashboard/application.css
      ]
    end
    
    initializer "solid_cache_dashboard.instrumentation" do
      config.after_initialize do
        SolidCacheDashboard::Instrumentation.install
      end
    end
    
    initializer "solid_cache_dashboard.pagy" do
      # Include Pagy modules for pagination support across different versions
      # Single source of truth: SolidCacheDashboard.pagy_43_or_newer?
      ActiveSupport.on_load(:action_controller) do
        if SolidCacheDashboard.pagy_43_or_newer?
          # Pagy >= 43.0: Use Pagy::Method for controllers
          include Pagy::Method
        else
          # Pagy 6.0-42.x: Use Pagy::Backend for controllers
          include Pagy::Backend
        end
      end
      
      ActiveSupport.on_load(:action_view) do
        unless SolidCacheDashboard.pagy_43_or_newer?
          # Pagy 6.0-42.x: Include Pagy::Frontend for views
          include Pagy::Frontend
        end
        # Pagy 43+ doesn't require view helper inclusion (we use pagy object attributes directly)
      end
    end
  end
end
