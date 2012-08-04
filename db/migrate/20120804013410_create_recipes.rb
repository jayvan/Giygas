class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.references :item
      t.integer :level
      t.references :profession
      t.timestamps
    end
  end
end
