class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :buy_value
      t.integer :sell_value
      t.timestamps
    end

    add_index(:items, :name, :unique => :true)
  end
end
