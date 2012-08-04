class Item < ActiveRecord::Base
  attr_accessible :buy_value, :name, :sell_value
  has_and_belongs_to_many :recipes
  has_many :items_recipes, :dependent => :destroy
end
