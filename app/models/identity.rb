class Identity < ActiveRecord::Base
  belongs_to :user

  ## VALIDATIONS
  validates :uid,       presence: true, uniqueness: { scope: :provider }
  validates :provider,  presence: true

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
