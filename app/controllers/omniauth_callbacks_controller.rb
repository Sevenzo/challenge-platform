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

        if user.nil?
          user = User.create_from_omniauth(auth)
        elsif user.uid != auth.uid
          user.update_from_omniauth(auth)
        end
      end

      sign_in_and_redirect user
    end
  end

  def failure
    flash[:danger] = "Sorry, there was an error logging you in. Please contact us at <a href='mailto:#{ENV.fetch('APP_EMAIL')}' target='_blank'>#{ENV.fetch('APP_EMAIL')}</a> for further assistance.".html_safe
    redirect_to new_user_session_url
  end

end
