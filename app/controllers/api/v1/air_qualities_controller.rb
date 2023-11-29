module Api
    module V1
      class AirQualitiesController < ApplicationController
        rescue_from StandardError, with: :handle_error
  
        def most_recent_per_location
          @most_recent_records = AirQuality.joins(:location).select('DISTINCT ON (location_id) *').order('location_id, timestamp DESC')
          render json: @most_recent_records
        end
  
        def average_per_month_per_location
            @average_per_month_per_location = AirQuality.joins(:location)
            .select('EXTRACT(MONTH FROM air_qualities.timestamp) as month,
                     locations.id as location_id,
                     locations.name as location_name,
                     locations.state as location_state,
                     locations.country as location_country,
                     AVG(air_qualities.aqi) as average_aqi,
                     to_char(air_qualities.timestamp, \'Mon\') as month_name')
            .group('month, location_id, month_name, locations.id, locations.name, locations.state, locations.country')
          render json: @average_per_month_per_location
        end
  
        def average_per_location
          @average_per_location = AirQuality.joins(:location)
          .select('locations.id as location_id,
                   locations.name as location_name,
                   locations.state as location_state,
                   locations.country as location_country,
                   AVG(air_qualities.aqi) as average_aqi')
          .group('locations.id, locations.name, locations.state, locations.country')
          render json: @average_per_location
        end
  
        def average_per_state
            @average_per_state = AirQuality.joins(:location)
            .select('locations.state as location_state,
                     AVG(air_qualities.aqi) as average_aqi')
            .group('locations.state')
          render json: @average_per_state
        end
  
        private
  
        def handle_error(exception)
          render json: { error: exception.message }, status: :internal_server_error
        end
      end
    end
  end
  