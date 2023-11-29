require 'rails_helper'

RSpec.describe ImportAqiHistoryJob, type: :job do
  include ActiveJob::TestHelper


  it 'imports AQI history for a location' do
    # Stub the AirQualityImporterService to return a sample AQI history
    location = create(:location)
    aqi_infos = [
      { 'main' => { 'aqi' => 50 }, 'components' => 'Some concentrations', 'dt' => Time.now.to_i }
      # Add more sample data as needed
    ]
    allow(AirQualityImporterService).to receive(:import_historical_data_for_location).and_return(aqi_infos)

    # Enqueue the job
    perform_enqueued_jobs do
      ImportAqiHistoryJob.perform_later(location.id)
    end

    # Assert that the job has been performed
    expect(ImportAqiHistoryJob).to have_been_performed

    # Assert that the location's air_qualities have been created
    expect(location.reload.air_qualities.count).to eq(aqi_infos.count)

    # Assert that the job status has been updated to 'Completed'
    job_tracker = ImportJob.find_by(job_type: 'ImportAqiHistoryJob')
    expect(job_tracker.status).to eq('Completed')
  end

  it 'handles errors and retries the job' do
    # Stub the AirQualityImporterService to simulate an error
    location = create(:location)
    allow(AirQualityImporterService).to receive(:import_historical_data_for_location).and_return(nil)

    # Enqueue the job
    perform_enqueued_jobs do
      ImportAqiHistoryJob.perform_later(location.id)
    end

    # Assert that the job status has been updated to 'Failed'
    job_tracker = ImportJob.find_by(job_type: 'ImportAqiHistoryJob')
    expect(job_tracker.retry_count).to eq(3)
    expect(job_tracker.status).to eq('Failed')
  end
end
