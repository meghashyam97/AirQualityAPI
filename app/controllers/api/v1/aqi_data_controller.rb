module Api
    module V1
        class AqiDataController < ApplicationController
            def create
                # Enqueue the job using Sidekiq
                job_tracker_id = ImportAqiHistoryJob.perform_later()

                render json: { message: 'Geo data update job has been enqueued.', job_tracker_id: job_tracker_id }
            end
        end
    end
end