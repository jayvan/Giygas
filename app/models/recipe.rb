class Recipe < ActiveRecord::Base
  attr_accessible :level, :profession_id, :item_id, :quantity
  has_and_belongs_to_many :items
  has_many :items_recipes, :dependent => :destroy
  belongs_to :item
  belongs_to :profession
  belongs_to :rarity

  def self.profitable
    profitable_recipes = []
    Recipe.find_each do |recipe|
      profitable_recipes << recipe if recipe.profit_margin >= 0
    end
    return profitable_recipes
  end

  def self.valid
    valid_recipes = []
    Recipe.find_each do |recipe|
      if recipe.item.sell_value == 0 # Output item can't be sold
        next 
      end
      
      valid = true

      recipe.items.each do |ingredient|
        if ingredient.buy_value == 0 # Ingredient can't be bought
          valid = false
          break
        end
      end

      valid_recipes << recipe if valid
    end

    return valid_recipes
  end

  def items_recipes
    ItemsRecipes.where(:recipe_id => self.id).includes(:item)
  end

  def print_costs
    if (self.item.sell_value == 0)
      puts "#{self.item.name} has no buyers on the market"
    else
      puts "#{self.item.name} sells for #{self.item.sell_value} on the market."
    end

    ItemsRecipes.where(:recipe_id => self.id).each do |itemrecipe|
      puts "  #{itemrecipe.quantity}x #{itemrecipe.item.name} @ #{itemrecipe.item.buy_value.to_i} = #{itemrecipe.item.buy_value.to_i * itemrecipe.quantity}"
    end
    
    puts "Net Value: #{self.profit_margin}"
  end

  def profit_margin
    if items.map(&:buy_value).reject{|n| n != 0}.any?
      # Cannot purchase an ingredient
      return 0
    end

    profit_margin = item.real_sale_value

    ItemsRecipes.where(:recipe_id => self.id).each do |itemrecipe|
      profit_margin -= itemrecipe.quantity * itemrecipe.item.buy_value
    end

    return profit_margin
  end
end
