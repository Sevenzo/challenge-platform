class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    auth = request.env["omniauth.auth"]
    if auth.info.email.blank?
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email,public_profile" and return
    end

    # Check for an existing user with this email
    @user = User.find_by_email(auth.info.email)

    # If this email is already associated with a user
    if @user
      # Is that user registered with the same provider?
        # log them in.
      # Else
        # "associate" their acc't with facebook
        # Is that user logged in already?
          # Redirect to the homepage with flash message "You've successfully connected your Facebook account"
        # else
          # sign_in_and_redirect @user with flash message "You've successfully connected your Facebook account""
      # End
    else
      # Is the user logged in already? This will catch the case of me having a different email for FB acct than my current sevenzo account (at least, if i'm already signed in, otherwise, we won't know, and we'll create two accounts. Not sure that this edge case can be avoided.)
        # "associate" their acc't with facebook
        # Redirect to the homepage with flash message "You've successfully connected your Facebook account"
      # Else,
        # Assume they're a new user, and create an account
      # End
    end
  end
end
