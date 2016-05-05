class ExperienceStagesController < ApplicationController

  def show
    # raise params.inspect
    @challenge = Challenge.find(params[:challenge_id])
    @experience_stage = @challenge.experience_stage
    @themes = @experience_stage.themes
    @featured_experiences = @experience_stage.experiences.where(featured: true)
  end

end
