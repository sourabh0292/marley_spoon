class RecipesController < ApplicationController
  before_action :load_recipe, only: :show

  def index
    @all_recipes = ContentfulService.new.get_recipes
  end

  def show; end

  private

  def load_recipe
    entry_id = params[:id]
    @recipe_data = JSON.parse(ContentfulService.new.get_recipe(entry_id).body)
  end
end
