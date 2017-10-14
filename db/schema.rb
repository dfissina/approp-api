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

ActiveRecord::Schema.define(version: 20171014232537) do

  create_table "comunas", force: :cascade do |t|
    t.string "name"
    t.float "lat"
    t.float "lng"
    t.integer "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_comunas_on_region_id"
  end

  create_table "dislikes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_dislikes_on_property_id"
    t.index ["user_id"], name: "index_dislikes_on_user_id"
  end

  create_table "favourites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_favourites_on_property_id"
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_likes_on_property_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.decimal "price"
    t.integer "build_mtrs"
    t.integer "total_mtrs"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "property_type"
    t.integer "operation"
    t.integer "state"
    t.integer "currency"
    t.string "street"
    t.integer "number"
    t.integer "departament"
    t.string "tower"
    t.string "neighborhood"
    t.boolean "show_pin_map"
    t.integer "comuna_id"
    t.boolean "condominium"
    t.boolean "furniture"
    t.integer "orientation"
    t.integer "parking_lots"
    t.integer "cellar"
    t.decimal "expenses"
    t.boolean "pets"
    t.boolean "terrace"
    t.index ["comuna_id"], name: "index_properties_on_comuna_id"
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.float "lat"
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.date "birth_date"
    t.string "phone"
    t.string "cell_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_picture"
  end

end
