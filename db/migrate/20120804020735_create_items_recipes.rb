class CreateItemsRecipes < ActiveRecord::Migration
  def change
    create_table :items_recipes do |t|
      t.references :item
      t.references :recipe
      t.integer :quantity
      t.timestamps
    end
    
    add_index(:items_recipes, :item_id)
    add_index(:items_recipes, :recipe_id)
  end
end
