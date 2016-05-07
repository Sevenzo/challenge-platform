class Cookbook < ActiveRecord::Base
  belongs_to :recipe_stage
  has_many :recipes
  acts_as_commentable

  def challenge
    recipe_stage.challenge
  end
end
