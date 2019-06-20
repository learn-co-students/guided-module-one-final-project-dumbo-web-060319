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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190619205121) do

  create_table "battles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "opponent_id"
    t.datetime "battle_date"
    t.integer  "winner"
  end

  create_table "pokeballs", force: :cascade do |t|
    t.integer "pokemon_id"
    t.integer "user_id"
    t.boolean "on_team"
    t.integer "hp",         default: 5
  end

  create_table "pokemons", force: :cascade do |t|
    t.string  "name"
    t.string  "element_type"
    t.string  "ascii"
    t.integer "hp"
    t.float   "attack"
    t.float   "defense"
    t.float   "speed"
  end

  create_table "users", force: :cascade do |t|
    t.string  "name"
    t.integer "wins",   default: 0
    t.integer "losses", default: 0
  end

end
