class Identity < ActiveRecord::Base
  belongs_to :user

  serialize :data, Hash

  ## VALIDATIONS
  validates :uid,       presence: true, uniqueness: { scope: :provider }
  validates :provider,  presence: true

end
