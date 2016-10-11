class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  [:twitter, :facebook].each do |provider|
    define_method provider do

      auth = request.env['omniauth.auth']

      if auth.info.email.blank?
        return redirect_to email_missing_oauth_path(provider, auth)
      else
        email = auth.info.email.downcase
      end

      identity = Identity.find_or_initialize_from_omniauth(auth)

      if user_signed_in? # User is connecting from settings page; only can connect new services

        if identity.new_record? # should always be this case since they can't connect existing services
          identity.update!(user: current_user)
          current_user.send("update_from_#{provider}", auth)
          flash[:notice] = "Successfully linked your #{provider.capitalize} account!"
        else # this means someone else has access to that account, do nothing
          flash[:error] = "Sorry, that #{provider.capitalize} account is registered with another user. If you think that is an error, please contact us at <%= ENV.fetch('APP_EMAIL') %>."
        end

        redirect_to edit_user_registration_path(setting: 'account')

      else

        user = identity.user
        if user.nil? # Identity is new record
          user = User.find_by(email: email)

          if user.nil? # No user with email, treat like new user signup
            user = User.send("create_from_#{provider}", auth)
            identity.update!(user: user)
          else
            existing_identity = user.send("#{provider}_identity")
            if existing_identity # User already has identity with that provider, simply update it
              existing_identity.update!(data: auth, uid: auth.uid)
            else # User does not have identity with that provider, add to user
              identity.update!(user: user)
            end
            user.send("update_from_#{provider}", auth)
          end
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


private

  def email_missing_oauth_path(provider, auth)
    case provider
    when :facebook
      user_facebook_omniauth_authorize_path(auth_type: 'rerequest', scope: 'email,public_profile,user_location')
    when :twitter
      user_twitter_omniauth_authorize_path(auth_type: 'rerequest')
    end
  end

end
