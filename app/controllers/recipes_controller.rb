class RecipesController < ApplicationController
  caches_page :index
  
  def index
    @recipes = Recipe.valid.sort_by{|r| -r.profit_margin}
    @professions = Profession.all
  end
end
