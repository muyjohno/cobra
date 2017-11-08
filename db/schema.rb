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

ActiveRecord::Schema.define(version: 20171108103642) do

  create_table "pairings", force: :cascade do |t|
    t.integer "round_id"
    t.integer "player1_id"
    t.integer "player2_id"
    t.integer "table_number"
    t.integer "score1"
    t.integer "score2"
    t.integer "side"
    t.index ["player1_id"], name: "index_pairings_on_player1_id"
    t.index ["player2_id"], name: "index_pairings_on_player2_id"
    t.index ["round_id"], name: "index_pairings_on_round_id"
  end

  create_table "players", force: :cascade do |t|
    t.string  "name"
    t.integer "tournament_id"
    t.boolean "active",          default: true
    t.string  "corp_identity"
    t.string  "runner_identity"
    t.integer "seed"
    t.boolean "first_round_bye", default: false
    t.index ["tournament_id"], name: "index_players_on_tournament_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "number"
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.integer  "pairing_sort", default: 0
    t.string   "abr_code"
    t.integer  "stage",        default: 0
    t.integer  "previous_id"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_tournaments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "nrdb_id"
    t.string   "nrdb_username"
    t.string   "nrdb_access_token"
    t.string   "nrdb_refresh_token"
    t.index ["nrdb_id"], name: "index_users_on_nrdb_id"
  end

end
