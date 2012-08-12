class DefaultBuyAndSellCost < ActiveRecord::Migration
  def up
    change_column_default(:items, :buy_value, 0)
    change_column_default(:items, :sell_value, 0)
    Item.find_each do |item|
      item.buy_value = 0 if item.buy_value.nil?
      item.sell_value = 0 if item.sell_value.nil?
      item.save
    end
  end

  def down
  end
end
