require 'rails_helper'

RSpec.describe Api::V1::AirQualitiesController, type: :controller do
  describe 'GET #most_recent_per_location' do
    it 'returns a successful response with meaningful data' do
      location = create(:location)
      air_quality = create(:air_quality, location: location)

      get :most_recent_per_location
      expect(response).to be_successful
      response_body = JSON.parse(response.body)
      expect(response_body[0]["aqi"]).to eq air_quality.aqi
    end
  end

  describe 'GET #average_per_month_per_location' do
    it 'returns a successful response with meaningful data' do
      location = create(:location)
      air_quality = create(:air_quality, location: location)
      air_quality2 = create(:air_quality, location: location , aqi: 5)

      get :average_per_month_per_location
      expect(response).to be_successful
      response_body = JSON.parse(response.body)
      expect(response_body[0]["average_aqi"]).to eq "4.5"
    end
  end

  describe 'GET #average_per_location' do
    it 'returns a successful response with meaningful data' do
      location = create(:location)
      air_quality = create(:air_quality, location: location)
      air_quality2 = create(:air_quality, location: location , aqi: 5)


      get :average_per_location
      expect(response).to be_successful
      response_body = JSON.parse(response.body)
      expect(response_body[0]["location_name"]).to eq "Bangalore"
      expect(response_body[0]["average_aqi"]).to eq "4.5"
    end
  end

  describe 'GET #average_per_state' do
    it 'returns a successful response with meaningful data' do
      location = create(:location)
      air_quality = create(:air_quality, location: location)
      air_quality2 = create(:air_quality, location: location , aqi: 5)


      get :average_per_state
      expect(response).to be_successful
      response_body = JSON.parse(response.body)
      expect(response_body[0]["location_state"]).to eq "Karnataka"
      expect(response_body[0]["average_aqi"]).to eq "4.5"
    end
  end
end
