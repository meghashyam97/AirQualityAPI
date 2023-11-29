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

ActiveRecord::Schema[7.1].define(version: 2023_11_28_075013) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "air_qualities", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.integer "aqi"
    t.json "pollutant_concentration"
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_air_qualities_on_location_id"
  end

  create_table "import_jobs", force: :cascade do |t|
    t.string "job_type"
    t.string "status"
    t.integer "retry_count"
    t.string "error_message"
    t.text "logs"
    t.string "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.string "country"
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "air_qualities", "locations"
end
