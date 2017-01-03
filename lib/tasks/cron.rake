namespace :cron do
  desc 'Executes available cron jobs through rake'

  task daily: :environment do
    Notifications.digest :daily
  end

  task weekly: :environment do
    Notifications.digest :weekly
  end
end
