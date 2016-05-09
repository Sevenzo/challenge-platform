class SolutionStagesController < ApplicationController

  def show
    @challenge = Challenge.find(params[:challenge_id])
    @solution_stage = @challenge.solution_stage
    @solution_stories = @solution_stage.solution_stories
    @ordering_criteria = valid_params
  end

  private

  def valid_params
    # Alternative to the default_scope's ordering.
    if params[:order_by] == 'latest'
      'created_at DESC'
    end
  end
end
