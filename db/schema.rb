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

ActiveRecord::Schema[8.0].define(version: 2025_08_20_012846) do
  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "workout_instances", force: :cascade do |t|
    t.integer "workout_session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "workout_id", null: false
    t.index ["workout_id"], name: "index_workout_instances_on_workout_id"
    t.index ["workout_session_id"], name: "index_workout_instances_on_workout_session_id"
  end

  create_table "workout_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_workout_sessions_on_user_id"
  end

  create_table "workout_sets", force: :cascade do |t|
    t.integer "reps", null: false
    t.integer "workout_instance_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit", null: false
    t.integer "amount", null: false
    t.index ["workout_instance_id"], name: "index_workout_sets_on_workout_instance_id"
  end

  create_table "workouts", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_workouts_on_author_id"
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "workout_instances", "workout_sessions", on_delete: :cascade
  add_foreign_key "workout_instances", "workouts", on_delete: :cascade
  add_foreign_key "workout_sessions", "users", on_delete: :cascade
  add_foreign_key "workout_sets", "workout_instances", on_delete: :cascade
  add_foreign_key "workouts", "users", column: "author_id", on_delete: :cascade
end
