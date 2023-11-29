require 'rails_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
end

RSpec.describe GeocodingService, type: :service do
  describe '.fetch_location_info' do
    let(:query) { 'Bangalore, Karnataka, India' }

    context 'when the request is successful' do
      it 'fetches location info using VCR' do
        VCR.use_cassette('geocoding_service/successful_request') do
          location_info = GeocodingService.fetch_location_info(query)
          expect(location_info).to eq({ latitude: 12.9767936, longitude: 77.590082 })
        end
      end
    end

    context 'when the request fails' do
      it 'handles the error using VCR' do
        VCR.use_cassette('geocoding_service/failed_request') do
          location_info = GeocodingService.fetch_location_info('InvalidQuery')
          expect(location_info).to be_nil
        end
      end
    end
  end
end
