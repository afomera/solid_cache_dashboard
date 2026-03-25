require "test_helper"

class DashboardIntegrationTest < ActionDispatch::IntegrationTest
  class TestController < SolidCacheDashboard::ApplicationController
    def pagination_test
      50.times do |i|
        SolidCache::Entry.create!(
          key: "test_key_#{i}",
          value: "test_value_#{i}",
          key_hash: 1000 + i,
          byte_size: 100
        )
      end

      @pagy, @cache_entries = pagy(SolidCache::Entry.order(created_at: :desc), items: 10)
      @cache_entries = SolidCacheDashboard.decorate(@cache_entries)

      render inline: <<~ERB
        <%= render partial: "solid_cache_dashboard/application/pagination",
                   locals: {
                     pagy: @pagy,
                     path_for_page: ->(page) { "/test?page=\#{page}" },
                     item_name: "entry"
                   } %>
      ERB
    end
  end

  setup do
    SolidCache::Entry.destroy_all

    Rails.application.routes.draw do
      get "pagination_test" => "dashboard_integration_test/test#pagination_test"
    end
  end

  teardown do
    SolidCache::Entry.destroy_all
  end

  test "pagination renders correctly with Pagy version #{Pagy::VERSION}" do
    get "/pagination_test"

    assert_response :success

    # Check page info text (numbers are wrapped in spans)
    assert_includes response.body, ">50<"
    assert_includes response.body, "entries"

    if SolidCacheDashboard.pagy_43_or_newer?
      # Pagy 43+ uses series_nav which renders a <nav class="pagy series-nav">
      assert_select "nav.pagy", count: 1
    else
      # Older Pagy uses custom nav
      assert_select "nav[aria-label=\"Pagination\"]", count: 1
    end

    # Verify no errors about undefined methods
    refute_match(/undefined method/, response.body)
    refute_match(/NoMethodError/, response.body)
  end

  test "navigation between pages works correctly" do
    get "/pagination_test?page=2"

    assert_response :success

    if SolidCacheDashboard.pagy_43_or_newer?
      # Pagy 43+ series_nav generates its own links
      assert_select "nav.pagy a[href*=\"page=1\"]"
      assert_select "nav.pagy a[href*=\"page=3\"]"
    else
      assert_select "a[href=\"/test?page=1\"]"
      assert_select "a[href=\"/test?page=3\"]"
    end
  end
end
