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

ActiveRecord::Schema[7.0].define(version: 2022_09_12_144139) do
  create_table "bus_arrivals", force: :cascade do |t|
    t.string "line_number"
    t.string "destination"
    t.integer "mins_to_arrive"
    t.integer "bus_stop_arrivals_infos_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bus_stop_arrivals_infos_id"], name: "index_bus_arrivals_on_bus_stop_arrivals_infos_id"
  end

  create_table "bus_stop_arrivals_infos", force: :cascade do |t|
    t.string "stop_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bus_arrivals", "bus_stop_arrivals_infos", column: "bus_stop_arrivals_infos_id"
end
