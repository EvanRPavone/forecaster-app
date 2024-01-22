require "test_helper"

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  test "Show forecast based on input address" do
    address = "3544 Bainford Drive"
    get root_url, params: { address: address }
    assert_response :success
    assert_equal address, session[:address]
  end
end
