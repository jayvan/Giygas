class Recipe < ActiveRecord::Base
  attr_accessible :level, :profession_id, :item_id, :name, :quantity
  has_and_belongs_to_many :items
  has_many :items_recipes, :dependent => :destroy
  belongs_to :item
end
