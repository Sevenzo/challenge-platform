class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "============================="
    puts "user.persisted? #{@user.persisted?}"
    puts "user.id #{@user.id}"
    puts "user.email #{@user.email}"
    puts "user.first_name #{@user.first_name}"
    puts "user.last_name #{@user.last_name}"
    puts "user.role #{@user.role}"
    puts "user.display_name #{@user.display_name}"

    sign_in_and_redirect @user
  end
end
