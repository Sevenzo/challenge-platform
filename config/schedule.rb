set :environment, ENV['RAILS_ENV']

every :day, :at => '4:30pm' do
  rake 'cron:daily'
end

every :friday, :at => '4:30pm' do
  rake 'cron:weekly'
end
