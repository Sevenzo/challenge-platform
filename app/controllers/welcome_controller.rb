class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      # TODO(Stedman): Rework this. We want signed-in user to be able to get back to the home page, but for their default to be the featured Challenge.
      @featured_challenge = Challenge.featured
      redirect_to challenge_path(@featured_challenge)
    end
  end
end
