module Api
    module V1
        class GeoDataController < ApplicationController
            def create
                # Enqueue the job using Sidekiq
                locations = Location.all()
                locations.each do |location|
                    job_tracker_id = GeoDataUpdateJob.perform_later(location.id)
                end

                render json: { message: 'Geo data update job has been enqueued.' }
            end
        end
    end
end