require 'rails_helper'

RSpec.describe GeoDataUpdateJob, type: :job do
  include ActiveJob::TestHelper


  it 'updates location coordinates and logs information' do
    # Stub the GeocodingService to return a hash with latitude and longitude
    location = create(:location)
    allow(GeocodingService).to receive(:fetch_location_info).and_return({ latitude: 123, longitude: 456 })

    # Enqueue the job
    perform_enqueued_jobs do
      GeoDataUpdateJob.perform_later
    end

    # Assert that the job has been performed
    expect(GeoDataUpdateJob).to have_been_performed

    # Assert that the location coordinates have been updated
    expect(location.reload.latitude.to_i).to eq(123)
    expect(location.reload.longitude.to_i).to eq(456)

    # Assert that the job status has been updated to 'Completed'
    job_tracker = ImportJob.find_by(job_type: 'GeoDataUpdateJob')
    expect(job_tracker.status).to eq('Completed')
  end

  it 'handles errors and retries the job' do
    # Stub the GeocodingService to simulate an error
    location = create(:location)
    allow(GeocodingService).to receive(:fetch_location_info).and_return(nil)

    # Enqueue the job
    perform_enqueued_jobs do
      GeoDataUpdateJob.perform_later
    end

    # Assert that the job status has been updated to 'Failed'
    job_tracker = ImportJob.find_by(job_type: 'GeoDataUpdateJob')
    expect(job_tracker.retry_count).to eq(3)
    expect(job_tracker.status).to eq('Failed')
  end
end
