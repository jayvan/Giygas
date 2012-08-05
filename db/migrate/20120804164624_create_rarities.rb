class CreateRarities < ActiveRecord::Migration
  def change
    create_table :rarities do |t|
      t.string :name
      t.integer :value
      t.timestamps
    end
    add_index(:rarities, :name, :unique => :true)

    Rarity.create!(:name => "Basic", :value => 1)
    Rarity.create!(:name => "Fine", :value => 2)
    Rarity.create!(:name => "Masterwork", :value => 3)
    Rarity.create!(:name => "Rare", :value => 4)
    Rarity.create!(:name => "Exotic", :value => 5)
    Rarity.create!(:name => "Legendary", :value => 6)
  end
end
