class ForecastsController < ApplicationController
  def show
    @default_address = "103 Duden Ct"
    session[:address] = params[:address]
    begin
      @address = params[:address]
      @geocode = GeocodeService.call(@address)
      @weather_cache_key = "#{@geocode.country_code}/#{@geocode.postal_code}"
      @weather_cache_exist = Rails.cache.exist?(@weather_cache_key)
      @weather = Rails.cache.fetch(@weather_cache_key, expires_in: 30.minutes) do
        WeatherService.call(@geocode.latitude, @geocode.longitude)          
      end
      # CONVERT PRESSURE FROM MILLIBAR(mbar) TO INCH OF MERCURY(inHg) -> Round to 2 decimal places
      @pressure = (@weather.pressure / 33.8639).round(2)
    rescue => e
      # If there are any errors from the Geocode service, return the error msg here
      flash.alert = e.message
    end
  end

end