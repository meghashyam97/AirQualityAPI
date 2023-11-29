module Api
    module V1
        class AqiDataController < ApplicationController
            def create
                # Enqueue the job using Sidekiq
                locations = Location.all()
                locations.each do |location|
                    job_tracker_id = ImportAqiHistoryJob.perform_later(location.id)
                end

                render json: { message: 'Import AQI history job has been enqueued.' }
            end
        end
    end
end