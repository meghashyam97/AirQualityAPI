require 'sidekiq'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/sidekiq-cron.yml"

    if File.exist?(schedule_file)
      schedule = YAML.load_file(schedule_file)

      Sidekiq::Cron::Job.load_from_hash!(schedule, source: "schedule")
    end
  end
end