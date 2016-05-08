class IdeaStage < ActiveRecord::Base
  belongs_to :challenge
  has_many :problem_statements
  has_many :ideas, through: :problem_statements

end
