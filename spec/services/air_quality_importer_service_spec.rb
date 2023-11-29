require 'rails_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end

RSpec.describe AirQualityImporterService, type: :service do
  describe 'import_for_location' do
    let(:location) { create(:location, latitude: 12.9767936, longitude: 77.590082) }

    it 'imports current AQI for a location using VCR and HTTParty' do
      VCR.use_cassette('air_quality_importer_service/current_aqi') do
        air_quality_data = AirQualityImporterService.import_for_location(location)
        expect(air_quality_data).to be_a(Hash)
      end
    end
  end

  describe 'import_historical_data_for_location' do
    let(:location) { create(:location, latitude: 12.9767936, longitude: 77.590082) }

    it 'imports historical AQI data for a location using VCR and HTTParty' do
      VCR.use_cassette('air_quality_importer_service/historical_aqi') do
        historical_aqi_data = AirQualityImporterService.import_historical_data_for_location(location,  Time.parse('2023-11-29 01:25:19.453473 UTC'))
        expect(historical_aqi_data).to be_an(Array)
        expect(historical_aqi_data.first).to be_a(Hash)
      end
    end
  end
end
