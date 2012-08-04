class CreateProfessions < ActiveRecord::Migration
  def change
    create_table :professions do |t|
      t.string :name
      t.timestamps
    end
    add_index(:professions, :name, :unique => :true)
  end
end
