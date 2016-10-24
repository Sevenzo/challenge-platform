source 'https://rubygems.org'
ruby '2.3.1'

## RAILS SETUP
gem 'rails'
gem 'pg'
gem 'unicorn'
gem 'active_model_serializers'
gem 'uglifier'
gem 'angular_rails_csrf'

## RAILS HELPERS
gem 'friendly_id'
gem 'numbers_and_words'
gem 'cocoon'
gem 'truncate_html'

## FRONT END JS ASSETS
source 'https://rails-assets.org' do
  gem 'rails-assets-underscore'
  gem 'rails-assets-angular'
  gem 'rails-assets-angular-resource'
  gem 'rails-assets-angular-sanitize'
  gem 'rails-assets-angular-animate'
  gem 'rails-assets-angular-scroll'
end

## FRONT-END GEMS
gem 'jquery-rails'
gem 'coffee-rails'
gem 'sass-rails'
gem 'autoprefixer-rails'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'bootstrap-switch-rails'
gem 'bourbon'
gem 'select2-rails'
gem 'redactor-rails'
gem 'client_side_validations'

## FILE/PHOTO UPLOADS
gem 'twitter'
gem 'mini_magick'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'carrierwave_backgrounder'

## VOTING
gem 'acts_as_votable', git: 'https://github.com/ryanto/acts_as_votable'

## COMMENTING
gem 'acts_as_commentable_with_threading'

## DELETING ENTITIES
gem 'paranoia'

## AUTHENTICATION/ADMINISTRATION
gem 'devise'
gem 'rails_admin'
gem 'kaminari'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

## MAILERS
gem 'mailkick'

## PERFORMANCE ENHANCEMENTS
gem 'newrelic_rpm'
gem 'memcachier'
gem 'dalli'
gem 'multi_fetch_fragments'

## DELAYED JOBS
gem 'sidekiq'
gem 'sinatra', require: false
gem 'exception_notification'

## VALIDATOR HELPER
gem 'public_suffix'

## SEEDING DATA
gem 'faker'

## Local Environment
group :development do
  gem 'web-console'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'spring'
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'pry'
  gem 'rb-readline'
end

group :test do
  gem 'webmock'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end

group :production do
  gem 'rails_12factor'
end
