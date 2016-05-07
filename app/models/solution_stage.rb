class SolutionStage < ActiveRecord::Base
  belongs_to :challenge
  has_many :solution_stories
  has_many :solutions, through: :solution_stories

end
