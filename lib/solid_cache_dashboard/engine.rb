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
      # Include Pagy modules in application controller and views
      ActiveSupport.on_load(:action_controller) do
        include Pagy::Backend
      end
      
      ActiveSupport.on_load(:action_view) do
        include Pagy::Frontend
      end
    end
  end
end
