# AirQualityAPI
A simple rails API app to fetch AQI data from Openweather APIs

## Features
1. Run a scheduled job to import current AQI for all locations.
2. An API endpoint to trigger the historical import ( one entry per week over the last year ) for all locations
3. An API endpoint to trigger the geo sync job to update the latitude and longitude of the locations
4. API endpoints for
    - Get the most recent AQI for all locations.
    - Get average AQI per month per location for all locations.
    - Get average AQI per location for all locations.
    - Get average AQI per state for all locations in the DB

## Prequisites
1. Ruby
2. Rails
3. Postgres ( local )
4. Redis ( server )

## Setup
1. Clone this repo
    git clone https://github.com/meghashyam97/AirQualityAPI.git
2. Install dependencies:
    bundle install
3. Database setup:
    rails db:create
    rails db:migrate
    rails db:seed

## Usage
The redis and postgres processes need to be running
The frequency of the job to fetch the current AQI can be configured at "config/sidekiq-cron.yml". Uncomment the line to set a frequency of 30 seconds
    # cron: "*/30 * * * * *"

1. Run the rails server
    rails s 
2. Run the sidekiq process
    bundle exec sidekiq

The jobs can be tracked through the sidekiq UI which is mounted at
    http://localhost:3000/sidekiq/cron
## Testing
This app contains tests for all the components.
The tests can be run using the following command
    bundle exec rspec   



