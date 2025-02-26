# Solid Cache Dashboard

A beautiful dashboard for [solid_cache](https://github.com/rails/solid_cache). Monitor your Rails application cache performance with detailed stats and visualizations.

## Features

- Real-time monitoring of cache hits, misses, writes, and deletes
- Visual charts to track cache performance over time
- Detailed views of all cache entries with size information
- Ability to inspect and delete individual cache entries
- Dark mode support
- Responsive design for all device sizes

## Screenshots

<p align="center">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/afomera/solid_cache_dashboard/refs/heads/main/docs/screenshots/dashboard_dark.png">
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/afomera/solid_cache_dashboard/refs/heads/main/docs/screenshots/dashboard_light.png">
      <img alt="Solid Cache Dashboard for Rails" src="https://raw.githubusercontent.com/afomera/solid_cache_dashboard/refs/heads/main/docs/screenshots/dashboard_light.png">
    </picture>
</p>
---

<p align="center">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/afomera/solid_cache_dashboard/refs/heads/main/docs/screenshots/stats_dark.png">
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/afomera/solid_cache_dashboard/refs/heads/main/docs/screenshots/stats_light.png">
      <img alt="Solid Cache Dashboard for Rails" src="https://raw.githubusercontent.com/afomera/solid_cache_dashboard/refs/heads/main/docs/screenshots/stats_light.png">
    </picture>
</p>

## Installation

Add this line to your application's Gemfile:

```ruby
gem "solid_cache_dashboard"
```

And then execute:

```bash
$ bundle install
```

Run the installation generator:

```bash
$ rails generate solid_cache_dashboard:install
$ rails db:migrate
```

This will create a migration for the cache events table that tracks cache hits, misses, writes, and deletes.

## Usage

Mount the dashboard in your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount SolidCacheDashboard::Engine => "/solid-cache"

  # The rest of your routes...
end
```

Now you can access the dashboard at `/solid-cache`.

## Configuration

You can configure the dashboard by creating an initializer:

```ruby
# config/initializers/solid_cache_dashboard.rb
SolidCacheDashboard.configure do |config|
  config.title = "My App Cache Dashboard"
end
```

## Authentication

For authentication, you can use routing constraints:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  authenticate :user, -> (user) { user.admin? } do
    mount SolidCacheDashboard::Engine => "/solid-cache"
  end
end
```

Or you can create a controller concern:

```ruby
# app/controllers/concerns/solid_cache_dashboard/authentication.rb
module SolidCacheDashboard
  module Authentication
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_solid_cache_dashboard
    end

    private

    def authenticate_solid_cache_dashboard
      if !user_signed_in? || !current_user.admin?
        redirect_to main_app.root_path, alert: "Not authorized"
      end
    end
  end
end
```

Then require it in an initializer:

```ruby
# config/initializers/solid_cache_dashboard.rb
Rails.application.config.to_prepare do
  SolidCacheDashboard::ApplicationController.include SolidCacheDashboard::Authentication
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/afomera/solid_cache_dashboard.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
