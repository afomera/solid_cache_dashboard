# frozen_string_literal: true

require_relative "lib/solid_cache_dashboard/version"

Gem::Specification.new do |spec|
  spec.name = "solid_cache_dashboard"
  spec.version = SolidCacheDashboard::VERSION
  spec.authors = ["Andrea Fomera"]
  spec.email = ["afomera@hey.com"]

  spec.summary = "Solid Cache Dashboard"
  spec.description = "Dashboard for Solid Cache"
  spec.homepage = "https://github.com/afomera/solid_cache_dashboard"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/afomera/solid_cache_dashboard"
  spec.metadata["changelog_uri"] = "https://github.com/afomera/solid_cache_dashboard/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |filename|
      (filename == gemspec) ||
        filename.start_with?(*%w[bin/ test/ spec/ features/ test_app/ .git .github Gemfile]) ||
        filename.end_with?(".gem") # Exclude gem files
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "solid_cache", ">= 0.2.0"
  spec.add_dependency "groupdate", ">= 6.5"
  spec.add_dependency "chartkick", ">= 5.0"
end
