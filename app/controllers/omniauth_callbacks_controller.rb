class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    auth = request.env['omniauth.auth']

    if auth.info.email.blank?
      redirect_to user_omniauth_authorize_path(
        :facebook,
        auth_type: 'rerequest',
        scope: 'email,public_profile'
      )
    else
      user = User.find_by(provider: auth.provider, uid: auth.uid)

      if user.nil?
        user = User.find_by(email: auth.info.email)

<<<<<<< HEAD
        if user.nil?
          user = User.create_from_omniauth(auth)
        elsif user.uid != auth.uid
          user.update_from_omniauth(auth)
        end
      end

      sign_in_and_redirect user
=======
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
>>>>>>> Complete the omniauth callback outline.
    end
  end

  def failure
    flash[:danger] = "Sorry, there was an error logging you in. Please try again, or contact us at <a href='mailto:#{ENV.fetch('APP_EMAIL')}' target='_blank'>#{ENV.fetch('APP_EMAIL')}</a> for further assistance.".html_safe
    redirect_to new_user_session_url
  end

end
