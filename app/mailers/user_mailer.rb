class UserMailer < ApplicationMailer
  default template_path: "mailers/#{mailer_name.split('_')[0].downcase}"

  default from: "Your #{ENV.fetch('APP_NAME')} Community Guides <#{ENV.fetch('APP_EMAIL')}>"

  def welcome(user_id)
    @resource = User.find(user_id)
    @subject = "Welcome to #{ENV.fetch('APP_NAME')}!"
  end
end
