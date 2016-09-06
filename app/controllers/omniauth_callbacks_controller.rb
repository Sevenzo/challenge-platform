class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    auth = request.env["omniauth.auth"]
    if auth.info.email.blank?
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email,public_profile" and return
    end

    # Check for an existing user with this email
    @user = User.find_by_email(auth.info.email)

    if user_signed_in?
      # If signed in, but the emails don't match
      if @user != current_user
        # associate
      end

      signed_in_root_path @user
    else
      # If not signed in, but the email is recognized
      if @user
        # If they're not associated with facebook
        if @user.provider != 'facebook'
          # associate
        end

      # If not signed in, and the email is not recognized
      else
        @user = User.from_omniauth(auth)
      end

      sign_in_and_redirect @user
    end
  end
end
