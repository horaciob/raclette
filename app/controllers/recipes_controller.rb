# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show]

  # GET /recipes or /recipes.json
  def index
    scope = if filter_params.present?
              Recipe.where(id: fitered_recipes_id).includes(:author, :category, :ingredients).page(params[:page])
            else
              Recipe.includes(:author, :category, :ingredients).page(params[:page])
            end
    @recipes = scope.includes(:author, :category, :ingredients).page(params[:page])
  end

  # GET /recipes/1 or /recipes/1.json
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:title, :cook_time, :prep_time, :rating, :author_id, :category_id)
  end

  def fitered_recipes_id
    ingredients = filter_params[:ingredients]&.uniq!&.reject(&:blank?)
    Recipe.by_ingredients(ingredients).pluck(:id)
  end

  def filter_params
    return [] unless params[:filters]

    params.require(:filters).permit(ingredients: [])
  end
end
