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

ActiveRecord::Schema.define(version: 2021_05_18_033840) do

  create_table "aupays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "customer_num", null: false
    t.string "client", null: false
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "get_date", null: false
    t.date "payment"
    t.string "status", null: false
    t.string "before_status"
    t.date "settlement"
    t.string "description"
    t.index ["customer_num"], name: "index_aupays_on_customer_num", unique: true
    t.index ["store_prop_id"], name: "index_aupays_on_store_prop_id"
    t.index ["user_id"], name: "index_aupays_on_user_id"
  end

  create_table "dmers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "customer_num", null: false
    t.string "client"
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "get_date", null: false
    t.date "payment"
    t.string "status", null: false
    t.string "before_status"
    t.text "description"
    t.date "settlement_payment"
    t.date "picture_payment"
    t.index ["customer_num"], name: "index_dmers_on_customer_num", unique: true
    t.index ["store_prop_id"], name: "index_dmers_on_store_prop_id"
    t.index ["user_id"], name: "index_dmers_on_user_id"
  end

  create_table "multi_summits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "summit_id"
    t.string "customer_num", null: false
    t.string "supply_num"
    t.date "payment"
    t.date "get_date", null: false
    t.index ["summit_id"], name: "index_multi_summits_on_summit_id"
  end

  create_table "pandas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "customer_num", null: false
    t.string "client", null: false
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "get_date", null: false
    t.date "payment"
    t.string "status", null: false
    t.string "before_status"
    t.string "image_status", null: false
    t.string "grid_id"
    t.string "food_category", null: false
    t.string "ghost_flag", null: false
    t.date "docu_sign_send"
    t.date "docu_sign_done"
    t.string "confirmer"
    t.date "solution_date"
    t.text "remarks"
    t.date "confirm_date"
    t.date "tarminal_send"
    t.date "result_point"
    t.index ["customer_num"], name: "index_pandas_on_customer_num", unique: true
    t.index ["store_prop_id"], name: "index_pandas_on_store_prop_id"
    t.index ["user_id"], name: "index_pandas_on_user_id"
  end

  create_table "paypays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "client", null: false
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "get_date", null: false
    t.date "payment"
    t.string "status", null: false
    t.string "before_status"
    t.index ["store_prop_id"], name: "index_paypays_on_store_prop_id"
    t.index ["user_id"], name: "index_paypays_on_user_id"
  end

  create_table "pranesses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "customer_num", null: false
    t.string "client"
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "get_date", null: false
    t.date "payment", null: false
    t.string "status", null: false
    t.bigint "stock_id"
    t.date "ssid_change"
    t.string "ssid_1", null: false
    t.string "pass_1", null: false
    t.string "ssid_2", null: false
    t.string "pass_2", null: false
    t.date "cancel"
    t.string "return_remarks"
    t.text "remarks"
    t.integer "claim", null: false
    t.date "start", null: false
    t.date "deadline", null: false
    t.date "withdrawal", null: false
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
    t.string "corporate_name"
    t.string "industry", null: false
    t.string "description"
    t.string "phone_number_1", null: false
    t.string "phone_number_2"
    t.string "person_main", null: false
    t.string "person_main_kana", null: false
    t.date "birthday"
    t.string "person_sub"
    t.string "person_sub_kana"
    t.string "mail_1", null: false
    t.string "mail_2"
    t.string "prefecture", null: false
    t.string "city", null: false
    t.string "municipalities", null: false
    t.string "address", null: false
    t.string "building_name"
    t.string "suitable_time", null: false
    t.string "holiday", null: false
    t.index ["name"], name: "index_store_props_on_name", unique: true
  end

  create_table "summits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "customer_num"
    t.string "client"
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "get_date", null: false
    t.date "payment"
    t.string "status", null: false
    t.string "before_status"
    t.string "claim_house", null: false
    t.string "claim_address", null: false
    t.string "before_electric"
    t.string "supply_num"
    t.string "pay_as"
    t.string "weight"
    t.string "menu", null: false
    t.date "start", null: false
    t.integer "fee"
    t.string "remarks"
    t.index ["customer_num"], name: "index_summits_on_customer_num", unique: true
    t.index ["store_prop_id"], name: "index_summits_on_store_prop_id"
    t.index ["user_id"], name: "index_summits_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "retiree"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "aupays", "store_props"
  add_foreign_key "aupays", "users"
  add_foreign_key "dmers", "store_props"
  add_foreign_key "dmers", "users"
  add_foreign_key "multi_summits", "summits"
  add_foreign_key "pandas", "store_props"
  add_foreign_key "pandas", "users"
  add_foreign_key "paypays", "store_props"
  add_foreign_key "paypays", "users"
  add_foreign_key "pranesses", "stocks"
  add_foreign_key "pranesses", "store_props"
  add_foreign_key "pranesses", "users"
  add_foreign_key "return_histories", "stocks"
  add_foreign_key "return_histories", "users"
  add_foreign_key "stock_histories", "stocks"
  add_foreign_key "stock_histories", "users"
  add_foreign_key "summits", "store_props"
  add_foreign_key "summits", "users"
end
