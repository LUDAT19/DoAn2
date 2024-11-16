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

ActiveRecord::Schema[7.2].define(version: 2024_11_04_042804) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "danhmucsanphams", force: :cascade do |t|
    t.string "ten_danhmuc"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100
    t.text "image_path"
    t.decimal "price", precision: 10
    t.integer "id_dm"
    t.text "mota"
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "phone_number", limit: 15
    t.string "address", limit: 255
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false

    t.unique_constraint ["name"], name: "roles_name_key"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "password_pidget", limit: 255, null: false
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.string "sdt", limit: 10
    t.string "diachi", limit: 255
    t.string "loai_quyen"
    t.string "username", limit: 255
    t.string "password_reset_token", limit: 255
    t.datetime "password_reset_sent_at", precision: nil
    t.integer "solandnthatbai", default: 0
    t.integer "isclock", default: 1

    t.unique_constraint ["email"], name: "users_username_key"
  end

  add_foreign_key "products", "danhmucsanphams", column: "id_dm", name: "fk_p_dm"
  add_foreign_key "profiles", "users", name: "profiles_user_id_fkey"
end
