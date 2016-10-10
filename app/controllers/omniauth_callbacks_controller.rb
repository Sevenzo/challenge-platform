class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  [:twitter, :facebook].each do |provider|
    define_method provider do

      auth = request.env['omniauth.auth']

      if auth.info.email.blank?
        return redirect_to send("user_#{provider}_omniauth_authorize(auth_type: 'rerequest', scope: 'email,public_profile')")
      else
        email = auth.info.email.downcase
      end

      identity = Identity.find_or_create_from_omniauth(auth)

      if user_signed_in?

        identity.update!(user: current_user) unless identity.user == current_user
        current_user.send("update_from_#{provider}", auth)
        flash[:notice] = "Successfully linked your #{provider.capitalize} account!"
        redirect_to edit_user_registration_path(setting: 'account')

      else

        user = identity.user
        if user.nil?
          user = User.find_by(email: email)

          if user.nil?
            user = User.send("create_from_#{provider}", auth)
          else
            user.send("update_from_#{provider}", auth)
          end

          identity.update!(user: user)
        end

        flash[:notice] = "Successfully logged in with #{provider.capitalize}!"
        sign_in_and_redirect user, event: :authentication

      end

    end
  end

  def failure
    flash[:danger] = "Sorry, there was an error logging you in. Please try again, or contact us at <a href='mailto:#{ENV.fetch('APP_EMAIL')}' target='_blank'>#{ENV.fetch('APP_EMAIL')}</a> for further assistance.".html_safe
    redirect_to new_user_session_url
  end

end
