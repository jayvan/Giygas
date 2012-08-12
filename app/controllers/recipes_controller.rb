class RecipesController < ApplicationController
  def index
    @professions = Profession.all
  end
end
