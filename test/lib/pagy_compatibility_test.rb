require "test_helper"

class PagyCompatibilityTest < ActiveSupport::TestCase
  test "pagy_43_or_newer? detects version correctly" do
    if Gem::Version.new(Pagy::VERSION) >= Gem::Version.new("43.0.0")
      assert SolidCacheDashboard.pagy_43_or_newer?
    else
      refute SolidCacheDashboard.pagy_43_or_newer?
    end
  end

  test "pagy_series works with pagy objects on older Pagy" do
    skip "Only applicable to Pagy < 43" if SolidCacheDashboard.pagy_43_or_newer?

    pagy = create_pagy(count: 100, page: 1, per_page: 10)
    series = SolidCacheDashboard.pagy_series(pagy)

    assert series.is_a?(Array)
    assert series.include?("1") # Current page as string
  end
end
