class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:twitter, :facebook].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      edit_user_registration_path(setting: 'onboard')
    end
  end

  # def facebook
  #   auth = request.env['omniauth.auth']

  #   if auth.info.email.blank?
  #     redirect_to user_facebook_omniauth_authorize(
  #       auth_type: 'rerequest',
  #       scope: 'email,public_profile'
  #     )
  #   else
  #     user = User.find_by(provider: auth.provider, uid: auth.uid)

  #     if user.nil?
  #       user = User.find_by(email: auth.info.email.downcase)

  #       if user.nil?
  #         user = User.create_from_omniauth(auth)
  #       elsif user.uid != auth.uid
  #         user.update_from_omniauth(auth)
  #       end
  #     end

  #     sign_in_and_redirect user
  #   end
  # end

  def failure
    flash[:danger] = "Sorry, there was an error logging you in. Please try again, or contact us at <a href='mailto:#{ENV.fetch('APP_EMAIL')}' target='_blank'>#{ENV.fetch('APP_EMAIL')}</a> for further assistance.".html_safe
    redirect_to new_user_session_url
  end

end
