require 'httparty'

class AirQualityImporterService
    include HTTParty
    base_uri 'https://api.openweathermap.org/data/2.5'

    def self.import_for_location(location)  
      air_quality_response = get('/air_pollution',  query: { lat: location.latitude, lon: location.longitude , appid: '63fca8ba7fe1a4df584d3ca19e3cbd37'})

      Rails.logger.info(air_quality_response)
      if air_quality_response.success?
        air_quality_data = air_quality_response['list'].first
        return air_quality_data
      else
        handle_error(response)
      end
    end
  
    def self.import_historical_data_for_location(location , end_date = Time.now.utc)
      start_date = end_date - 1.year
  
      current_date = start_date
      aqi_responses = []
      while current_date <= end_date
        historical_data_response = get('/air_pollution/history', query: { lat: location.latitude, lon: location.longitude ,
        start: current_date.to_i , end: current_date.to_i + 3600 , appid: '63fca8ba7fe1a4df584d3ca19e3cbd37'})
        Rails.logger.info("HTTParty Request: #{historical_data_response.request.http_method} #{historical_data_response.request.last_uri}")

        Rails.logger.info(historical_data_response)

        if historical_data_response.success?
            historical_data = historical_data_response['list'].first
            aqi_responses.push(historical_data)
        else
            handle_error(response)
            return nil
        end

        current_date += 1.week
      end
      return aqi_responses
    end

    private

    def self.handle_error(response)
      Rails.logger.error("Error fetching aqi info: #{response.code} - #{response.body}")
      nil
    end
  end
  