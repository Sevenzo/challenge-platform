class RecipeStage < ActiveRecord::Base
  belongs_to :challenge
  has_many :cookbooks
  has_many :recipes, through: :cookbooks

end
