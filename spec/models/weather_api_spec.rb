require 'rails_helper'
require 'forecast_io'

describe 'WeatherApi' do
  let(:longitude) { 1 }
  let(:latitude) { 45 }
  let(:options) { {params: { exclude: 'currently,minutely,hourly,alerts,flags'}} }
  let(:subject) { FetchForecastCommand.new(latitude, longitude) }

  before do
    allow(ForecastIO).to receive(:forecast)
  end

  it 'should use the provided long/lat in the request' do
    expect(ForecastIO).to receive(:forecast).with(latitude, longitude, options)
    subject.perform()
  end

  context 'when a date is provided' do
    it 'should use the date in the forecast request' do
      requested_date = 1.year.ago
      options[:time] = requested_date
      subject = FetchForecastCommand.new(latitude, longitude, requested_date)
      expect(ForecastIO).to receive(:forecast).with(latitude, longitude, options)
      subject.perform()
    end
  end

  let(:fake_utc_time) { 123 }
  let(:expected_date_time) { DateTime.now }
  let(:forecast_response) do
    {daily: {
      data: [
        {
          temperatureMin: 1,
          temperatureMax: 1,
          time: fake_utc_time
        },
        {
          temperatureMin: 1,
          temperatureMax: 1,
          time: fake_utc_time
        },
        {
          temperatureMin: 1,
          temperatureMax: 1,
          time: fake_utc_time
        }
      ]
    }
    }
  end

  it 'should return expected results' do

    Time.stub(:at).with(fake_utc_time) { expected_date_time }

    day1 = { name: Date::DAYNAMES[expected_date_time.wday], minTemp: 1, maxTemp: 1, time: fake_utc_time }
    day2 = { name: Date::DAYNAMES[expected_date_time.wday], minTemp: 1, maxTemp: 1, time: fake_utc_time }
    day3 = { name: Date::DAYNAMES[expected_date_time.wday], minTemp: 1, maxTemp: 1, time: fake_utc_time }

    allow(ForecastIO).to receive(:forecast) { forecast_response }

    expected_results = [day1, day2, day3]

    expect(subject.perform()).to eql expected_results
  end
end
