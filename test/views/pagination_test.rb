require "test_helper"
require "action_view/test_case"

class PaginationViewTest < ActionView::TestCase
  include SolidCacheDashboard::ApplicationHelper

  setup do
    @path_for_page = ->(page) { "/test?page=#{page}" }
    @item_name = "entry"
  end

  test "pagination partial renders without errors for single page" do
    pagy = create_pagy(count: 10, page: 1, per_page: 25)

    html = render_pagination(pagy)

    assert html.strip.empty? # Should render nothing when pages <= 1
  end

  test "previous attribute compatibility" do
    pagy = create_pagy(count: 100, page: 2, per_page: 10)

    if SolidCacheDashboard.pagy_43_or_newer?
      assert_equal 1, pagy.previous
    else
      assert_equal 1, pagy.prev
    end
  end

  private

  def render_pagination(pagy)
    render partial: "solid_cache_dashboard/application/pagination",
           locals: { pagy: pagy, path_for_page: @path_for_page, item_name: @item_name }
  end
end
