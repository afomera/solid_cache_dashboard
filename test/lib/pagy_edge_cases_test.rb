require "test_helper"

class PagyEdgeCasesTest < ActiveSupport::TestCase
  test "handles empty collections correctly" do
    pagy = create_pagy(count: 0, page: 1, per_page: 10)

    assert_equal 0, pagy.count
    assert_equal 1, pagy.page
    assert_equal 1, pagy.last
    refute pagy.next

    if SolidCacheDashboard.pagy_43_or_newer?
      refute pagy.previous
    else
      refute pagy.prev
    end
  end

  test "handles single page correctly" do
    pagy = create_pagy(count: 5, page: 1, per_page: 10)

    assert_equal 5, pagy.count
    assert_equal 1, pagy.pages
    refute pagy.next
  end

  test "handles last page correctly" do
    pagy = create_pagy(count: 50, page: 5, per_page: 10)

    assert_equal 5, pagy.page
    assert_equal 5, pagy.last
    refute pagy.next

    if SolidCacheDashboard.pagy_43_or_newer?
      assert_equal 4, pagy.previous
    else
      assert_equal 4, pagy.prev
    end
  end

  test "from and to calculations work correctly" do
    pagy = create_pagy(count: 25, page: 2, per_page: 10)

    assert_equal 11, pagy.from
    assert_equal 20, pagy.to
  end
end
