class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        binding.pry
        if @user.persisted? #even new users will be persisted at this point. Soooo need some other measure of whether they're "new" or not.
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_path
        end


      end
    }
  end

  [:twitter, :facebook].each do |provider|
    define_method provider do
      auth = request.env['omniauth.auth']

      # =====================================
      # TODO(Stedman): add #{provider} to path
      return redirect_to user_facebook_omniauth_authorize(
          auth_type: 'rerequest',
          scope: 'email,public_profile'
        ) if auth.info.email.blank?

      # Find or create the identity with the given provider and uid.
      @identity = Identity.find_or_create_from_omniauth(auth)

      if signed_in?
        if @identity.user == current_user
          # User is signed in so they are trying to link an identity with their
          # account. But we found the identity and the user associated with it
          # is the current user. So the identity is already associated with
          # this user. So let's display an error message.
          redirect_to root_url, notice: "Already linked that account!"
        else
          # A currently signed in user always overrides the existing user
          # to prevent the identity being locked with accidentally created accounts.
          # Note that this may leave zombie accounts (with no associated identity) which
          # can be cleaned up at a later date.
          @identity.user = current_user
          @identity.save

          # =====================================
          # TODO(Stedman): Provider name:
          redirect_to root_url, notice: "Successfully linked that account!"
        end
      else
        @user = User.where(email: email).first

        if @identity.user.present?
          # The identity we found had a user associated with it, so we log them in
          sign_in_and_redirect @identity.user, event: :authentication
        elsif @user
          # A user with the provider's email address already exists.
          # Associate the identity and log that user in.
          @identity.user = @user
          @identity.save

          sign_in_and_redirect @user, event: :authentication
        else
          # No user associated with this identity; treat this like a new user sign up.
          @user = User.create_from_omniauth(env["omniauth.auth"])

          sign_in_and_redirect @user
        end
      end
    end # define_method provider
  end # [:twitter, :facebook]

  def failure
    flash[:danger] = "Sorry, there was an error logging you in. Please try again, or contact us at <a href='mailto:#{ENV.fetch('APP_EMAIL')}' target='_blank'>#{ENV.fetch('APP_EMAIL')}</a> for further assistance.".html_safe
    redirect_to new_user_session_url
  end
end
