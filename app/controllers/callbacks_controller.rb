class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # The second argument (params) is used to set the user's Role.
    # See: http://stackoverflow.com/questions/7999907/passing-random-url-params-to-omniauth
    @user = User.from_omniauth(request.env["omniauth.auth"], request.env["omniauth.params"])

    flash[:success] = "You've signed in with Facebook!"
    sign_in_and_redirect @user
  end
end
