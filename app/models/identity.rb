class Identity < ActiveRecord::Base
  belongs_to :user

  ## VALIDATIONS
  validates :uid,       presence: true, uniqueness: { scope: :provider }
  validates :provider,  presence:  true

end
