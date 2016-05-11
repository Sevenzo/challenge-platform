class ExperienceStagesController < ApplicationController

  def show
    @challenge = Challenge.find(params[:challenge_id])
    @experience_stage = @challenge.experience_stage
    @themes = @experience_stage.themes
    @featured_experiences = @experience_stage.experiences.where(featured: true)
    @ordering_criteria = 'published_at DESC' if params[:order_by] == 'latest'
  end

end
