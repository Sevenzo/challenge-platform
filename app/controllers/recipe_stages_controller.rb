class RecipeStagesController < ApplicationController

  def show
    @challenge = Challenge.find(params[:challenge_id])
    @recipe_stage = @challenge.recipe_stage
    @cookbooks = @recipe_stage.cookbooks
    @featured_recipes = @recipe_stage.recipes.where(featured: true)
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
