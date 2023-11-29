require 'rails_helper'

RSpec.describe ImportCurrentAqiJob, type: :job do
  include ActiveJob::TestHelper


  it 'imports current AQI for a location' do
    # Stub the AirQualityImporterService to return a sample current AQI
    location = create(:location)
    aqi_info = { 'main' => { 'aqi' => 50 }, 'components' => 'Some concentrations', 'dt' => Time.now.to_i }
    allow(AirQualityImporterService).to receive(:import_for_location).and_return(aqi_info)

    # Enqueue the job
    perform_enqueued_jobs do
      ImportCurrentAqiJob.perform_later(location.id)
    end

    # Assert that the job has been performed
    expect(ImportCurrentAqiJob).to have_been_performed

    # Assert that the location's air_qualities have been created
    expect(location.reload.air_qualities.count).to eq(1)
    expect(location.reload.air_qualities[0].aqi).to eq(50)

    # Assert that the job status has been updated to 'Completed'
    job_tracker = ImportJob.find_by(job_type: 'ImportCurrentAqiJob')
    expect(job_tracker.status).to eq('Completed')
  end

  it 'handles errors and retries the job' do
    # Stub the AirQualityImporterService to simulate an error
    location = create(:location)
    allow(AirQualityImporterService).to receive(:import_for_location).and_return(nil)

    # Enqueue the job
    perform_enqueued_jobs do
      ImportCurrentAqiJob.perform_later(location.id)
    end

    # Assert that the job status has been updated to 'Failed'
    job_tracker = ImportJob.find_by(job_type: 'ImportCurrentAqiJob')
    expect(job_tracker.retry_count).to eq(3)
    expect(job_tracker.status).to eq('Failed')
  end
end
