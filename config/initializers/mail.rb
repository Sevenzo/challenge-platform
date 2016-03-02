ActionMailer::Base.smtp_settings = {
  port: '587',
  address: ENV.fetch('POSTMARK_SMTP_SERVER'),
  user_name: ENV.fetch('POSTMARK_API_TOKEN'),
  password: ENV.fetch('POSTMARK_API_TOKEN'),
  domain: 'heroku.com',
  authentication: :cram_md5,
  enable_starttls_auto: true
}

ActionMailer::Base.delivery_method = :smtp
