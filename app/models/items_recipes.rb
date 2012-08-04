class ItemsRecipes < ActiveRecord::Base
  attr_accessible :item_id, :quantity, :recipe_id
  belongs_to :item
  belongs_to :recipe
end
