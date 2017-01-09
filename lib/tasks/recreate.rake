require 'webmock/rspec' if Rails.env.development?

namespace :db do
  desc 'Drop, create, migrate then seed the database'
  task recreate: :environment do
    WebMock.allow_net_connect! if Rails.env.development?
    Rake::Task['log:clear'].invoke
    Rake::Task['tmp:clear'].invoke
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
    # sh "whenever -s environment=#{Rails.env} -w"
  end
end
