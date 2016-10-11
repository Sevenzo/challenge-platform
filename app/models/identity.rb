class Identity < ActiveRecord::Base
  belongs_to :user

  serialize :data, Hash

  ## VALIDATIONS
  validates :user_id,   presence: true
  validates :uid,       presence: true, uniqueness: { scope: :provider }
  validates :provider,  presence: true, uniqueness: { scope: :user_id }

  def self.find_or_initialize_from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |identity|
      identity.data = auth
    end
  end

  def best_avatar_url
    if provider == 'facebook'
      data.info.image
    elsif provider == 'twitter'
      data.info.image.sub('_normal', '_400x400')
    end
  end

end
