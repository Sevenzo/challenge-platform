class ExperienceStage < ActiveRecord::Base
  belongs_to :challenge
  has_many :themes
  has_many :experiences, through: :themes

end
