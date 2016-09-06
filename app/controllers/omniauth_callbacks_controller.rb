class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    auth = request.env["omniauth.auth"]
    if auth.info.email.blank?
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email,public_profile" and return
    end

    # Check for an existing user with this email
    @user = User.find_by_email(auth.info.email)

    if user_signed_in?
      # If the user is currently signed in, then either:
      # 1. they're already associated with Facebook, or
      # 2. they're not, and we need to associate their account.
      if @user != current_user
        # Associate the current_user with this facebook account
        current_user.update_from_omniauth(auth)
      end
      # In either case, alert them that they've linked their Facebook account.
      signed_in_root_path @user, notice: "You've successfully linked to Facebook!"
    else
      # Not signed in
      if @user
        # The facebook account's email is recognized
        if @user.provider != 'facebook'
          # @user is not associated with facebook,
          # associate the @user with this facebook account
          @user.update_from_omniauth(auth)
        end
      else
        # The facebook account's email is not recognized
        # This is the simple case: a new user creates an account via Facebook login.
        @user = User.create_from_omniauth(auth)
      end
      sign_in_and_redirect @user
    end
  end
end
