# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show]

  def index
    @recipes = if filter_params.present?
                 Recipe.where(id: fitered_recipes_id).includes(:author, :category, :ingredients).page(params[:page])
               else
                 Recipe.includes(:author, :category, :ingredients).page(params[:page])
               end
  end

  def show; end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def fitered_recipes_id
    ingredients = filter_params[:ingredients]&.uniq&.reject(&:blank?)

    Recipe.by_ingredients(ingredients).pluck(:id)
  end

  def filter_params
    return [] unless params[:filters]

    params.require(:filters).permit(ingredients: [])
  end
end
