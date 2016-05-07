class Feature < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge
  belongs_to :featureable, polymorphic: true

  before_validation :validate_panelist

  after_save { featureable.update_column(:featured, active) }

private

  def validate_panelist
    if user
      unless featureable.challenge.panelists.exists?(user.id)
        errors[:user] = "#{user.name} is not a panelist for \"#{featureable.challenge.title}\", so they cannot mark this content as featured."
      end
    end
  end

end
