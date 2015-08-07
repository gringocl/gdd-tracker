require 'forecast_io'

class WeatherApi
  def initialize(latitude, longitude, requested_date = nil)
    @latitude = latitude
    @longitude = longitude
    @requested_date = requested_date
  end

  def perform
    options = { params: {exclude: 'currently,minutely,hourly,alerts,flags'} }
    if @requested_date
      options[:time] = @requested_date
    end

    forecast_response = ForecastIO.forecast(@latitude, @longitude, options)

    formatted_response = []

    if forecast_response
      forecast_response[:daily][:data].map do |day|
        formatted_day = {}
        formatted_time = Time.at(day[:time])
        formatted_day[:name] = Date::DAYNAMES[formatted_time.wday]
        formatted_day[:time] = day[:time]
        formatted_day[:minTemp] = day[:temperatureMin]
        formatted_day[:maxTemp] = day[:temperatureMax]
        formatted_response << formatted_day
      end
    end

      formatted_response
  end

end

