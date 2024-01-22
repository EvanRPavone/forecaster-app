class ForecastsController < ApplicationController
  def show
    @default_address = "1 Infinite Loop"
    session[:address] = params[:address]
    begin
      @address = params[:address]
      @geocode = GeocodeService.call(@address)
      @weather_cache_key = "#{@geocode.country_code}/#{@geocode.postal_code}"
      @weather_cache_exist = Rails.cache.exist?(@weather_cache_key)
      @weather = Rails.cache.fetch(@weather_cache_key, expires_in: 30.minutes) do
        WeatherService.call(@geocode.latitude, @geocode.longitude)          
      end
      # CONVERT FROM CELSIUS TO FAHRENHEIT -> Round to nearest whole number
      @temperature = (@weather.temperature * 9/5 + 32).round
      @temperature_min = (@weather.temperature_min * 9/5 + 32).round
      @temperature_max = (@weather.temperature_max * 9/5 + 32).round
  
      # CONVERT FROM MILLIBAR(mbar) TO INCH OF MERCURY(inHg) -> Round to 2 decimal places
      @pressure = (@weather.pressure / 33.8639).round(2)
    rescue => e
      # If there are any errors from the Geocode service, return the error msg here
      flash.alert = e.message
    end
  end

end