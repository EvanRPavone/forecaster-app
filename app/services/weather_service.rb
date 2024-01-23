class WeatherService
    
  def self.call(latitude, longitude)
    conn = Faraday.new("https://api.openweathermap.org") do |f|
      f.request :json # encode req bodies as JSON and automatically set the Content-Type header
      f.request :retry # retry transient failures
      f.response :json # decode response bodies as JSON
    end    
    response = conn.get('/data/2.5/weather', {
      appid: Rails.application.credentials.openweather_api_key,
      # passes in the lat and long retrieved from GeocodeService
      lat: latitude,
      lon: longitude,
      # sets unit of measurement to imperial
      units: "imperial",
    })
    body = response.body
    body or raise IOError.new "OpenWeather response body failed"
    body["main"] or raise IOError.new "OpenWeather main section is missing"
    body["main"]["temp"] or raise IOError.new "OpenWeather temperature is missing"
    body["main"]["temp_min"] or raise IOError.new "OpenWeather temperature minimum is missing"
    body["main"]["temp_max"] or raise IOError.new "OpenWeather temperature maximum is missing"
    body["weather"] or raise IOError.new "OpenWeather weather section is missing"
    body["weather"].length > 0 or raise IOError.new "OpenWeather weather section is empty"
    body["weather"][0]["description"] or raise IOError.new "OpenWeather weather description is missing"
    weather = OpenStruct.new
    weather.temperature = body["main"]["temp"]
    weather.temperature_min = body["main"]["temp_min"]
    weather.temperature_max = body["main"]["temp_max"]
    weather.feels_like = body["main"]["feels_like"]
    weather.wind = body["wind"]["speed"]
    weather.wind_gust = body["wind"]["gust"]
    weather.humidity = body["main"]["humidity"]
    weather.pressure = body["main"]["pressure"]
    weather.description = body["weather"][0]["description"]
    weather
    # ALL WEATHER DATA: 
    # {
    #   "coord"=>{"lon"=>-78.8498, "lat"=>35.8971}, 
    #   "weather"=>[{"id"=>804, "main"=>"Clouds", "description"=>"overcast clouds", "icon"=>"04d"}],
    #   "base"=>"stations", 
    #   "main"=>{"temp"=>48.27, "feels_like"=>47.73, "temp_min"=>44.62, "temp_max"=>50.36, "pressure"=>1035, "humidity"=>47},
    #   "visibility"=>10000, 
    #   "wind"=>{"speed"=>3, "deg"=>311, "gust"=>4}, 
    #   "clouds"=>{"all"=>100}, 
    #   "dt"=>1706025683, 
    #   "sys"=>{"type"=>2, "id"=>2031626, "country"=>"US", "sunrise"=>1706012517, "sunset"=>1706049118}, 
    #   "timezone"=>-18000, 
    #   "id"=>4480285, 
    #   "name"=>"Morrisville", 
    #   "cod"=>200
    # }
  end
    
end