class ImportCurrentAqiSchedulerJob < ApplicationJob
    queue_as :default
    def perform()
        job_tracker = ImportJob.find_by(job_id: job_id)
        job_tracker = ImportJob.create_for_job('ImportCurrentAqiJobScheduler' , job_id) unless job_tracker.present?
        job_tracker.update_status('In Progress')
        locations = Location.all()

        begin
            locations.each do |location|
                ImportCurrentAqiJob.perform_later(location.id)
            end
            job_tracker.update_status('Completed')
        rescue StandardError => e
            job_tracker.log_error(e)
            should_retry = job_tracker.retry_or_fail(e)
            retry_job(wait: 1.minutes) if should_retry # Retry the job after 5 minutes
        end
    end
end
