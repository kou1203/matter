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

ActiveRecord::Schema.define(version: 2021_05_06_033508) do

  create_table "dmers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "store_prop_id"
    t.bigint "user_id"
    t.string "status", null: false
    t.date "get_date", null: false
    t.string "mail", null: false
    t.text "description"
    t.date "payment"
    t.date "settlement_payment"
    t.date "picture_payment"
    t.index ["store_prop_id"], name: "index_dmers_on_store_prop_id"
    t.index ["user_id"], name: "index_dmers_on_user_id"
  end

  create_table "pranesses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.bigint "stock_id"
    t.date "get_date", null: false
    t.date "ssid_change"
    t.string "ssid_1", null: false
    t.string "ssid_2", null: false
    t.string "pass_1", null: false
    t.string "pass_2", null: false
    t.date "cancel"
    t.string "return_remarks"
    t.text "remarks"
    t.integer "claim", null: false
    t.date "start", null: false
    t.date "deadline", null: false
    t.date "withdrawal", null: false
    t.date "payment", null: false
    t.index ["stock_id"], name: "index_pranesses_on_stock_id"
    t.index ["store_prop_id"], name: "index_pranesses_on_store_prop_id"
    t.index ["user_id"], name: "index_pranesses_on_user_id"
  end

  create_table "return_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "stock_id"
    t.date "return"
    t.index ["stock_id"], name: "index_return_histories_on_stock_id"
    t.index ["user_id"], name: "index_return_histories_on_user_id"
  end

  create_table "stock_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "stock_id"
    t.date "take_out"
    t.index ["stock_id"], name: "index_stock_histories_on_stock_id"
    t.index ["user_id"], name: "index_stock_histories_on_user_id"
  end

  create_table "stocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "stock_num", null: false
    t.string "mac_num", null: false
    t.string "status"
    t.string "mail", null: false
    t.text "remarks"
    t.index ["stock_num", "mac_num"], name: "index_stocks_on_stock_num_and_mac_num", unique: true
  end

  create_table "store_props", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "race"
    t.string "name", null: false
    t.string "suitable_time", null: false
    t.text "description"
    t.string "industry", null: false
    t.string "phone_number_1", null: false
    t.string "phone_number_2"
    t.string "person_main", null: false
    t.string "person_sub"
    t.string "prefectures", null: false
    t.string "city", null: false
    t.string "municipalities", null: false
    t.string "address", null: false
    t.string "building_name"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "dmers", "store_props"
  add_foreign_key "dmers", "users"
  add_foreign_key "pranesses", "stocks"
  add_foreign_key "pranesses", "store_props"
  add_foreign_key "pranesses", "users"
  add_foreign_key "return_histories", "stocks"
  add_foreign_key "return_histories", "users"
  add_foreign_key "stock_histories", "stocks"
  add_foreign_key "stock_histories", "users"
end
