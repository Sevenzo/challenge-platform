class Cookbook < ActiveRecord::Base
  belongs_to :recipe_stage
  has_many :recipes
  acts_as_commentable

  delegate :challenge, to: :recipe_stage

end
