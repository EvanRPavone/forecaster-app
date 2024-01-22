require "application_system_test_case"

class ForecastsTest < ApplicationSystemTestCase

  test "show" do
    address = "3544 Bainford Drive"
    visit url_for \
      controller: "forecasts", 
      action: "show", 
      params: { 
        address: address 
      }
    assert_selector "h5", text: "Forecast"
  end

end
