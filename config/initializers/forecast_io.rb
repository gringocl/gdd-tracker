require 'forecast_io'

ForecastIO.configure do |configuration|
  configuration.api_key = ENV['FORECAST_IO_APP_KEY']
end
