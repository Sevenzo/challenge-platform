class IdeaStagesController < ApplicationController

  def show
    @challenge = Challenge.find(params[:challenge_id])
    @idea_stage = @challenge.idea_stage
    @problem_statements = @idea_stage.problem_statements
    @featured_ideas = @idea_stage.ideas.where(featured: true)
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
