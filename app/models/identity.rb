class Identity < ActiveRecord::Base
  belongs_to :user

  serialize :data, Hash

  ## VALIDATIONS
  validates :uid,       presence: true, uniqueness: { scope: :provider }
  validates :provider,  presence: true

  def self.find_or_create_from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |identity|
      identity.data = auth
    end
  end

end
