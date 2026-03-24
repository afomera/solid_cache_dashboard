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
      # Pagy 43+ uses Pagy::Method (controllers only; views use pagy object attributes)
      # Pagy 6-8.x uses Pagy::Backend (controllers) and Pagy::Frontend (views)
      ActiveSupport.on_load(:action_controller) do
        if defined?(Pagy::Method)
          # Pagy >= 43.0
          include Pagy::Method
        elsif defined?(Pagy::Backend)
          # Pagy 6.0-8.x
          include Pagy::Backend
        else
          raise "[solid_cache_dashboard] Unable to load Pagy. Please ensure Pagy >= 6.0 is installed."
        end
      end
      
      # Views only need Pagy::Frontend in older versions (< 43)
      # In Pagy 43+, views directly access pagy object attributes without helper inclusion
      ActiveSupport.on_load(:action_view) do
        if defined?(Pagy::Frontend)
          # Pagy 6.0-8.x
          include Pagy::Frontend
        end
        # Pagy 43+ doesn't require view helper inclusion for our use case
      end
    end
  end
end
