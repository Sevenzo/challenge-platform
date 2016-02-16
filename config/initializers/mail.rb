ActionMailer::Base.smtp_settings = {
  port: '587',
  address: 'smtp.mandrillapp.com',
  user_name: ENV.fetch('MANDRILL_USERNAME'),
  password: ENV.fetch('MANDRILL_APIKEY'),
  domain: 'heroku.com',
  authentication: :plain
}

ActionMailer::Base.delivery_method = :smtp
