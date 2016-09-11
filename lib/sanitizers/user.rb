class User::ParameterSanitizer < Devise::ParameterSanitizer

  def initialize(*)
    super
    permit(:sign_up, keys: sign_up_attrs)
    permit(:account_update, keys: account_update_attrs)
  end

  def sign_up_attrs
    [
      :first_name,
      :last_name,
      :email,
      :password,
      :remember_me,
      :referrer_id
    ]
  end

  def account_update_attrs
    [
      :first_name,
      :last_name,
      :email,
      :current_password,
      :password,
      :password_confirmation,
      :display_name,
      :twitter,
      :avatar_option,
      :avatar,
      :remote_avatar_url,
      :remove_avatar,
      :avatar_cache,
      :role,
      :title,
      :organization,
      :bio,
      { state_ids: [] },
      { district_ids: [] },
      { school_ids: [] },
      :comment_posted,
      :comment_replied,
      :comment_followed
    ]
  end

end
