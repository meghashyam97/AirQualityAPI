Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :geo_data, only: [:create], controller: 'geo_data'
      resources :aqi_data, only: [:create], controller: 'aqi_data'
      resources :air_qualities, only: [] do
        collection do
          get :most_recent_per_location
          get :average_per_month_per_location
          get :average_per_location
          get :average_per_state
        end
      end
    end
  end
end
