# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120812172800) do

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "buy_value",  :default => 0
    t.integer  "sell_value", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "rarity_id"
    t.integer  "level"
    t.string   "image_url"
  end

  add_index "items", ["name", "level", "rarity_id"], :name => "index_items_on_name_and_level_and_rarity_id", :unique => true

  create_table "items_recipes", :force => true do |t|
    t.integer  "item_id"
    t.integer  "recipe_id"
    t.integer  "quantity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "items_recipes", ["item_id"], :name => "index_items_recipes_on_item_id"
  add_index "items_recipes", ["recipe_id"], :name => "index_items_recipes_on_recipe_id"

  create_table "professions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "professions", ["name"], :name => "index_professions_on_name", :unique => true

  create_table "rarities", :force => true do |t|
    t.string   "name"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "rarities", ["name"], :name => "index_rarities_on_name", :unique => true

  create_table "recipes", :force => true do |t|
    t.integer  "item_id"
    t.integer  "level"
    t.integer  "profession_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
