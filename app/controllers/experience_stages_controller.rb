class ExperienceStagesController < ApplicationController

  def show
    @challenge = Challenge.find(params[:challenge_id])
    @experience_stage = @challenge.experience_stage
    @themes = @experience_stage.themes
    @featured_experiences = @experience_stage.experiences.where(featured: true)
    @ordering_criteria = valid_params
  end

  private

  def valid_params
    # Alternative to the default_scopes ordering.
    if params[:order_by] == 'latest'
      'created_at DESC'
    end
  end
end
