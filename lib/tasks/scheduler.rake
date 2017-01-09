desc 'This task is called by the Heroku scheduler add-on'

task send_daily_digests: :environment do
  puts 'BEGIN: Sending daily digests'
  Notifications.digest(:daily)
  puts 'DONE: Sending daily digests'
end

task send_weekly_digests: :environment do
  if Time.now.friday?
    puts 'BEGIN: Sending weekly digests'
    Notifications.digest(:weekly)
    puts 'DONE: Sending weekly digests'
  end
end
