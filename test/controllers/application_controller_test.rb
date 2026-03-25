require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  class TestController < SolidCacheDashboard::ApplicationController
    def index
      collection = SolidCache::Entry.all
      @pagy, @records = pagy(collection, items: 25)

      prev_page = SolidCacheDashboard.pagy_43_or_newer? ? @pagy.previous : @pagy.prev

      render json: {
        pagy_class: @pagy.class.name,
        total_count: @pagy.count,
        current_page: @pagy.page,
        previous_page: prev_page,
        next_page: @pagy.next,
        pages: @pagy.pages,
        limit: @pagy.respond_to?(:limit) ? @pagy.limit : @pagy.items
      }
    end
  end

  setup do
    10.times do |i|
      SolidCache::Entry.create!(
        key: "key_#{i}",
        value: "value_#{i}",
        key_hash: i,
        byte_size: 100
      )
    end

    Rails.application.routes.draw do
      get "test" => "application_controller_test/test#index"
    end
  end

  teardown do
    SolidCache::Entry.destroy_all
  end

  test "pagy wrapper creates correct pagy object for current version" do
    get "/test"

    json = JSON.parse(response.body)

    assert_response :success

    if SolidCacheDashboard.pagy_43_or_newer?
      assert_match(/Pagy::Offset/, json["pagy_class"])
      assert_equal 25, json["limit"]
    else
      assert_match(/Pagy/, json["pagy_class"])
      assert_equal 25, json["limit"]
    end

    assert_equal 10, json["total_count"]
    assert_equal 1, json["current_page"]
  end

  test "first page has next but no previous" do
    create_extra_entries(40)

    get "/test"
    json = JSON.parse(response.body)

    assert_equal 50, json["total_count"]
    assert_equal 1, json["current_page"]
    assert_nil json["previous_page"]
    assert_equal 2, json["next_page"]
  end

  test "middle page has both previous and next" do
    create_extra_entries(40)

    get "/test?page=2"
    json = JSON.parse(response.body)

    assert_equal 50, json["total_count"]
    assert_equal 2, json["current_page"]
    assert_equal 1, json["previous_page"]
    assert_equal 2, json["pages"]
  end

  test "last page has previous but no next" do
    create_extra_entries(90)

    get "/test?page=4"
    json = JSON.parse(response.body)

    assert_equal 100, json["total_count"]
    assert_equal 4, json["current_page"]
    assert_equal 3, json["previous_page"]
    assert_nil json["next_page"]
    assert_equal 4, json["pages"]
  end

  private

  def create_extra_entries(count)
    count.times do |i|
      SolidCache::Entry.create!(
        key: "extra_key_#{i}",
        value: "extra_value_#{i}",
        key_hash: 100 + i,
        byte_size: 100
      )
    end
  end
end
