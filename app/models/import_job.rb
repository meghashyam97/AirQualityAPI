class ImportJob < ApplicationRecord
    MAX_RETRIES = 3
  
    def self.create_for_job(job_type , job_id)
      create(job_type: job_type, status: 'Queued', retry_count: 0 , job_id: job_id)
    end
  
    def update_status(status)
      update(status: status)
    end
  
    def log_error(error)
      update(error_message: error.message)
      Rails.logger.error("Error in #{job_type}: #{error.message}")
    end
  
    def retry_or_fail(error)
      if retry_count < MAX_RETRIES
        update(retry_count: retry_count + 1)
        return true
      else
        update(status: 'Failed')
        Rails.logger.error("#{job_type} failed after #{MAX_RETRIES} retries: #{error.message}")
        return false
      end
    end
end
