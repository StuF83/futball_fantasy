# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_10_132301) do
  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_week_matches", force: :cascade do |t|
    t.integer "game_week_id", null: false
    t.integer "match_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_week_id"], name: "index_game_week_matches_on_game_week_id"
    t.index ["match_id"], name: "index_game_week_matches_on_match_id"
  end

  create_table "game_weeks", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "week_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_predictions", force: :cascade do |t|
    t.integer "home_score_guess"
    t.integer "away_score_guess"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "match_id", null: false
    t.index ["match_id"], name: "index_match_predictions_on_match_id"
    t.index ["user_id"], name: "index_match_predictions_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.string "home_team"
    t.string "away_team"
    t.integer "home_score"
    t.integer "away_score"
    t.date "scheduled_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_competitions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "competition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_user_competitions_on_competition_id"
    t.index ["user_id"], name: "index_user_competitions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "game_week_matches", "game_weeks"
  add_foreign_key "game_week_matches", "matches"
  add_foreign_key "match_predictions", "matches"
  add_foreign_key "match_predictions", "users"
  add_foreign_key "user_competitions", "competitions"
  add_foreign_key "user_competitions", "users"
end
