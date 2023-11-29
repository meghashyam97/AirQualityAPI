class ImportCurrentAqiJob < ApplicationJob
    queue_as :default
  
    def perform(location_id)
        job_tracker = ImportJob.find_by(job_id: job_id)
        job_tracker = ImportJob.create_for_job('ImportCurrentAqiJob' , job_id) unless job_tracker.present?
        job_tracker.update_status('In Progress')

        location = Location.find(location_id)
        begin
            update_location_aqi(location)
            job_tracker.update_status('Completed')
        rescue StandardError => e
            job_tracker.log_error(e)
            should_retry = job_tracker.retry_or_fail(e)
            retry_job(wait: 1.minutes) if should_retry # Retry the job after 5 minutes
        end
    end
  
    private
  
    def update_location_aqi(location)
        aqi_info = AirQualityImporterService.import_for_location(location)
        Rails.logger.info(aqi_info)
        if aqi_info.present?
            location.air_qualities.create(
                aqi: aqi_info['main']['aqi'],
                pollutant_concentration: aqi_info['components'],
                timestamp: Time.at(aqi_info['dt'])
            )
        else
            Rails.logger.error("Failed to fetch aqi info for #{location.name}, #{location.state}, #{location.country}")
            raise StandardError.new("The aqi info could not be fetched.")
        end
    end
end