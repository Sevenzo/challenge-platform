class UserMailerPreview < ActionMailer::Preview

  def welcome
    UserMailer.welcome(1)
  end

end
