class ApplicationController < ActionController::Base
  include RoutingConcern
  include CachingConcern
  include PersistenceConcern

  before_action :capture_referrer_id
  protect_from_forgery with: :null_session

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  helper_method :resource, :resource_name, :devise_mapping

  def devise_parameter_sanitizer
    if resource_class == User
      User::ParameterSanitizer.new(User, :user, params)
    else
      super
    end
  end

  def load_challenge
    @challenge ||= Challenge.find(params[:challenge_id])
  end

private

  def capture_referrer_id
    return if user_signed_in?
    session[:referrer_id] ||= params[:referrer_id] if params[:referrer_id]
  end

  def object_flash_message_for(object, options = {})
    if object.destroyed_at?
      action = 'deleted'
    else
      if %w(experience idea recipe).include?(object.class.to_s.downcase)
        if object.published_at?
          action = object.created_at == object.updated_at ? 'shared' : options[:published] ? 'published' : 'updated'
        else
          action = object.created_at == object.updated_at ? 'saved a draft of' : 'updated the draft of'
        end
      else
        action = object.created_at == object.updated_at ? 'shared' : 'updated'
      end
    end

    message = "You've successfully #{action} your #{object.class.name.downcase}. <a href='#{user_path(object.user)}'>Click here</a> to see all of your contributions."

    return message
  rescue
  end

end
