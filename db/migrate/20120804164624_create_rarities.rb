class CreateRarities < ActiveRecord::Migration
  def change
    create_table :rarities do |t|
      t.string :name
      t.integer :value
      t.timestamps
    end
    add_index(:rarities, :name, :unique => :true)

    Rarity.create!(:name => "common", :value => 1)
    Rarity.create!(:name => "fine", :value => 2)
    Rarity.create!(:name => "masterwork", :value => 3)
    Rarity.create!(:name => "rare", :value => 4)
    Rarity.create!(:name => "exotic", :value => 5)
    Rarity.create!(:name => "legendary", :value => 6)
  end
end
