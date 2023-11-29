FactoryBot.define do
    factory :air_quality do
      transient do
        aqi { 4 } # Default value
      end
  
      pollutant_concentration { 'Some concentrations' }
      timestamp { Time.now }
      location
  
      after(:build) do |air_quality, evaluator|
        air_quality.aqi = evaluator.aqi
      end
    end
  end