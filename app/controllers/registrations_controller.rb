class RegistrationsController < Devise::RegistrationsController

  def edit
    set_edit_setting
  end

  def create
    super do |resource|
      UserMailer.delay.welcome(resource.id) if resource.persisted?
    end
  end

  #
  # Update a user registration
  #
  # This method is overridden from the Devise method call because we need to parse the
  # strings of district ids
  def update
    set_edit_setting
    check_password_needed
    # We're persisting the check before the super block.
    # If we do not, the existing resource values will be the same as the params.
    avatar_updated = avatar_updated?

    # checking if it's digest frequency change back to immediately
    digest_frequency_updated = digest_frequency_updated?

    super do |resource|
      if resource.errors.empty?
        update_avatar(resource) if avatar_updated

        # flushing pending notifications for users that decided to go back to
        # immediately digest frequency
        Notifications.flush(resource) if digest_frequency_updated
      end
    end
  end

private

  #
  # Parse both district_ids into arrays
  #
  # Affects the params instance variable, does not return anything.
  def check_password_needed
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
      params[:user].delete(:current_password)
    end
  end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    if params[:password].nil?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  def set_edit_setting
    @setting = params[:user] ? params[:user][:setting] : params[:setting]
    @setting = 'profile' unless @setting && ['profile', 'account', 'onboard', 'notifications'].include?(@setting)
  end

  def after_update_path_for(resource)
    stored_location_for(resource) ||
      (featured_challenge_path if @setting == 'onboard') ||
      edit_user_registration_path(setting: @setting)
  end

  def update_avatar(resource)
    if params[:user][:avatar_option] == 'none'
      resource.remove_avatar!
      resource.save
    elsif params[:user][:avatar_option] == 'twitter'
      resource.delay.set_avatar_from_twitter
    elsif params[:user][:avatar_option] == 'facebook'
      resource.delay.set_avatar_from_facebook
    end
  end

  def avatar_updated?
    twitter_avatar = params[:user][:avatar_option] == 'twitter' && resource.avatar_option != 'twitter'
    facebook_avatar = params[:user][:avatar_option] == 'facebook' && resource.avatar_option != 'facebook'
    remove_avatar = resource.avatar.present? && params[:user][:avatar_option] == 'none'
    twitter_avatar || facebook_avatar || remove_avatar
  end

  #
  # Checks if a user changed its email digest frequency back to `immediately`.
  # In that case, after update, a flush must happen for pending queued
  # notifications
  def digest_frequency_updated?
    frequency = params[:user][:digest_frequency]

    frequency == 'immediately' && frequency != resource.digest_frequency
  end
end
