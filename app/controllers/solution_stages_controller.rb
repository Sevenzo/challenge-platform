class SolutionStagesController < ApplicationController

  def show
    @challenge = Challenge.find(params[:challenge_id])
    @solution_stage = @challenge.solution_stage
    @solution_stories = @solution_stage.solution_stories
    @ordering = 'created_at DESC' unless params[:order_by] == 'popular'
  end

end
