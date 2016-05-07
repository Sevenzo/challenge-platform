class ProblemStatement < ActiveRecord::Base
  belongs_to :idea_stage
  has_many :ideas
end
