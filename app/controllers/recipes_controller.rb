class RecipesController < ApplicationController
  def index
    @recipes = Recipe.valid
    @professions = Profession.all
  end
end
