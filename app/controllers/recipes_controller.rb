class RecipesController < ApplicationController
  caches_page :index
  
  def index
    @recipes = Recipe.valid
    @professions = Profession.all
  end
end
