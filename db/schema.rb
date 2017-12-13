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

ActiveRecord::Schema.define(version: 20171212235546) do

  create_table "account_hashes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "hashcode"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password"
    t.index ["user_id"], name: "index_account_hashes_on_user_id"
  end

  create_table "comunas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "name"
    t.float "lat", limit: 24
    t.float "lng", limit: 24
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_comunas_on_region_id"
  end

  create_table "dislikes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "user_id"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_dislikes_on_property_id"
    t.index ["user_id"], name: "index_dislikes_on_user_id"
  end

  create_table "favourites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "user_id"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_favourites_on_property_id"
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.bigint "user_id"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_likes_on_property_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "message_contacts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.text "message"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.bigint "sender_user_id"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_message_contacts_on_property_id"
    t.index ["sender_user_id"], name: "index_message_contacts_on_sender_user_id"
  end

  create_table "properties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "title"
    t.text "description"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.decimal "price", precision: 10
    t.integer "build_mtrs"
    t.integer "total_mtrs"
    t.bigint "user_id"
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
    t.bigint "comuna_id"
    t.boolean "condominium"
    t.boolean "furniture"
    t.integer "orientation"
    t.integer "parking_lots"
    t.integer "cellar"
    t.decimal "expenses", precision: 10
    t.boolean "pets"
    t.boolean "terrace"
    t.float "lat", limit: 24
    t.float "lng", limit: 24
    t.string "cod"
    t.integer "views", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.index ["comuna_id"], name: "index_properties_on_comuna_id"
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "property_photos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.text "photo"
    t.integer "order"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_property_photos_on_property_id"
  end

  create_table "regions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
    t.string "name"
    t.float "lat", limit: 24
    t.float "lng", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci" do |t|
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
    t.integer "rol"
    t.boolean "password_reseted"
    t.boolean "account_active"
    t.boolean "facebook_account"
    t.datetime "last_login"
  end

  add_foreign_key "account_hashes", "users"
  add_foreign_key "comunas", "regions"
  add_foreign_key "dislikes", "properties"
  add_foreign_key "dislikes", "users"
  add_foreign_key "favourites", "properties"
  add_foreign_key "favourites", "users"
  add_foreign_key "likes", "properties"
  add_foreign_key "likes", "users"
  add_foreign_key "message_contacts", "properties"
  add_foreign_key "message_contacts", "users", column: "sender_user_id"
  add_foreign_key "properties", "comunas"
  add_foreign_key "properties", "users"
  add_foreign_key "property_photos", "properties"
end
