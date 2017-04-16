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

ActiveRecord::Schema.define(version: 20170416075129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pairings", force: :cascade do |t|
    t.integer "round_id"
    t.integer "player1_id"
    t.integer "player2_id"
    t.integer "table_number"
    t.index ["player1_id"], name: "index_pairings_on_player1_id", using: :btree
    t.index ["player2_id"], name: "index_pairings_on_player2_id", using: :btree
    t.index ["round_id"], name: "index_pairings_on_round_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.string  "name"
    t.integer "tournament_id"
    t.index ["tournament_id"], name: "index_players_on_tournament_id", using: :btree
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "number"
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id", using: :btree
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "pairings", "players", column: "player1_id"
  add_foreign_key "pairings", "players", column: "player2_id"
  add_foreign_key "pairings", "rounds"
  add_foreign_key "players", "tournaments"
  add_foreign_key "rounds", "tournaments"
end
