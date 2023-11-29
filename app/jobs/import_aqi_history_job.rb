class ImportAqiHistoryJob < ApplicationJob
    queue_as :default
  
    def perform(*args)
        locations = Location.all()
        Rails.logger.info(job_id)
        job_tracker = ImportJob.find_by(job_id: job_id)
        job_tracker = ImportJob.create_for_job('ImportAqiHistoryJob' , job_id) unless job_tracker.present?
        job_tracker.update_status('In Progress')

        begin
        locations.each do |location|
            update_location_aqi_history(location)
        end

        job_tracker.update_status('Completed')
        rescue StandardError => e
        job_tracker.log_error(e)
        should_retry = job_tracker.retry_or_fail(e)
        retry_job(wait: 1.minutes) if should_retry # Retry the job after 5 minutes
        end
    end
  
    private
  
    def update_location_aqi_history(location)
        aqi_infos = AirQualityImporterService.import_historical_data_for_location(location)
        Rails.logger.info(aqi_infos)
        if aqi_infos.present?
            aqi_infos.each do |aqi_info|
                # Check if 'aqi_info' and 'aqi_info['dt']' are not nil before using them
                if aqi_info && aqi_info['dt']
                    location.air_qualities.create(
                        aqi: aqi_info['main']['aqi'],
                        pollutant_concentration: aqi_info['components'],
                        timestamp: Time.at(aqi_info['dt'])
                    )
                else
                  # Handle the case where aqi_info or aqi_info['dt'] is nil
                  Rails.logger.error("Error: aqi_info or timestamp is nil")
                  raise StandardError.new("The aqi info could not be fetched.")
                end
            end
        else
            Rails.logger.error("Failed to fetch aqi info for #{location.name}, #{location.state}, #{location.country}")
            raise StandardError.new("The aqi info could not be fetched.")
        end
    end
end