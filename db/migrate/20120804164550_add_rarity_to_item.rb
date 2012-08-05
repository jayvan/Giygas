class AddRarityToItem < ActiveRecord::Migration
  def change
    add_column :items, :rarity_id, :integer
    add_column :items, :level, :integer
    add_index :items, [:name, :level, :rarity_id], :unique => :true
  end
end
