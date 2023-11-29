require 'httparty'

class GeocodingService
  include HTTParty
  base_uri 'https://api.openweathermap.org/geo/1.0'

  def self.fetch_location_info(query)
    response = get('/direct', query: { q: query, limit: 1, appid: '63fca8ba7fe1a4df584d3ca19e3cbd37'})

    if response.success?
      Rails.logger.info(response)
      data = response.parsed_response.first
      return { latitude: data['lat'], longitude: data['lon'] } if data.present?
    else
      handle_error(response)
    end
  end

  private

  def self.handle_error(response)
    Rails.logger.error("Error fetching location info: #{response.code} - #{response.body}")
    nil
  end
end
