# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_31_144947) do

  create_table "markups", force: :cascade do |t|
    t.string "markup_type"
    t.integer "user_id"
    t.integer "post_id"
    t.string "category"
    t.string "title"
    t.text "content"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "leadin"
    t.date "date"
    t.date "expires"
    t.index ["category"], name: "index_markups_on_category"
    t.index ["markup_type"], name: "index_markups_on_markup_type"
    t.index ["user_id"], name: "index_markups_on_user_id"
  end

  create_table "members", force: :cascade do |t|
    t.integer "post_id"
    t.integer "vfw_id"
    t.string "first_name"
    t.string "mi"
    t.string "last_name"
    t.string "full_name"
    t.string "phone"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "status"
    t.string "email"
    t.string "type_pay"
    t.string "pay_year"
    t.string "pay_status"
    t.date "pay_date"
    t.string "country"
    t.string "paid_thru"
    t.string "days_remaining"
    t.string "last_status"
    t.text "served"
    t.string "alt_phone"
    t.integer "age"
    t.string "undeliverable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["full_name"], name: "index_members_on_full_name"
    t.index ["post_id"], name: "index_members_on_post_id"
    t.index ["vfw_id"], name: "index_members_on_vfw_id"
  end

  create_table "officers", force: :cascade do |t|
    t.integer "post_id"
    t.integer "member_id"
    t.string "position"
    t.string "full_name"
    t.date "from_date"
    t.date "to_date"
    t.boolean "current"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seq"
    t.index ["post_id"], name: "index_officers_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "district_id"
    t.string "name"
    t.integer "numb"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "phone"
    t.string "zip"
    t.string "email"
    t.string "fax"
    t.string "web"
    t.string "txt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "department"
    t.index ["district_id"], name: "index_posts_on_district_id"
    t.index ["numb"], name: "index_posts_on_numb"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "post_id"
    t.string "type_report"
    t.string "area"
    t.date "date"
    t.string "details"
    t.string "updated_by"
    t.integer "volunteers"
    t.float "hours_each"
    t.float "total_hours"
    t.float "miles_each"
    t.float "total_miles"
    t.float "expenses"
    t.text "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_reports_on_post_id"
  end

  create_table "stashes", force: :cascade do |t|
    t.integer "post_id", null: false
    t.string "type"
    t.string "key"
    t.date "date"
    t.text "hash_data"
    t.text "array_data"
    t.text "text_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_stashes_on_post_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_type"
    t.string "email"
    t.string "username"
    t.string "full_name"
    t.string "roles"
    t.string "reset_token"
    t.integer "post"
    t.integer "district"
    t.string "department"
    t.string "password_digest"
  end

  add_foreign_key "markups", "posts"
  add_foreign_key "members", "posts"
  add_foreign_key "reports", "posts"
  add_foreign_key "stashes", "posts"
end
