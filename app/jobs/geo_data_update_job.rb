class GeoDataUpdateJob < ApplicationJob
    queue_as :default
  
    def perform(*args)
        locations = Location.all()
        Rails.logger.info(job_id)
        job_tracker = ImportJob.find_by(job_id: job_id)
        job_tracker = ImportJob.create_for_job('GeoDataUpdateJob' , job_id) unless job_tracker.present?
        job_tracker.update_status('In Progress')

        begin
        locations.each do |location|
            update_location_coordinates(location)
        end

        job_tracker.update_status('Completed')
        rescue StandardError => e
        job_tracker.log_error(e)
        should_retry = job_tracker.retry_or_fail(e)
        retry_job(wait: 1.minutes) if should_retry # Retry the job after 5 minutes
        end
    end
  
    private
  
    def update_location_coordinates(location)
        location_info = GeocodingService.fetch_location_info("#{location.name}, #{location.state}, #{location.country}")
        Rails.logger.info(location_info)
        if location_info.present?
            location.update(latitude: location_info[:latitude], longitude: location_info[:longitude])
        else
            Rails.logger.error("Failed to fetch location info for #{location.name}, #{location.state}, #{location.country}")
            raise StandardError.new("The location info could not be fetched.")
        end
    end
end