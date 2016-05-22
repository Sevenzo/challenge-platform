class Feature < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge
  belongs_to :featureable, polymorphic: true

  after_save { featureable.update_column(:featured, active) }

end
