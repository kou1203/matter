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

ActiveRecord::Schema.define(version: 2021_07_06_093513) do

  create_table "actual_profits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item", null: false
    t.integer "profit", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "aupays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "customer_num"
    t.string "client", null: false
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "date", null: false
    t.string "status", null: false
    t.date "status_update"
    t.bigint "settlementer_id"
    t.date "settlement"
    t.date "settlement_deadline"
    t.string "status_settlement", null: false
    t.date "status_update_settlement"
    t.date "payment"
    t.date "payment_settlement"
    t.integer "profit_new", null: false
    t.integer "profit_settlement", null: false
    t.integer "valuation_new", null: false
    t.integer "valuation_settlement", null: false
    t.string "description"
    t.index ["customer_num"], name: "index_aupays_on_customer_num", unique: true
    t.index ["settlementer_id"], name: "index_aupays_on_settlementer_id"
    t.index ["store_prop_id"], name: "index_aupays_on_store_prop_id"
    t.index ["user_id"], name: "index_aupays_on_user_id"
  end

  create_table "costs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "month", null: false
    t.string "base", null: false
    t.integer "sales_man", null: false
    t.integer "office_worker", null: false
    t.integer "social_insurance", null: false
    t.integer "administrator", null: false
    t.integer "sales_man_cost", null: false
    t.integer "office_worker_cost", null: false
    t.integer "office", null: false
    t.integer "utility_net_cost", null: false
    t.integer "dorm", null: false
    t.integer "bonus_stock", null: false
    t.integer "travel_stock", null: false
    t.integer "other", null: false
    t.date "update_date"
  end

  create_table "dmers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "customer_num", null: false
    t.string "client", null: false
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "date", null: false
    t.string "status", null: false
    t.date "status_update"
    t.bigint "settlementer_id"
    t.date "settlement"
    t.date "settlement_deadline"
    t.string "status_settlement", null: false
    t.date "status_update_settlement"
    t.date "payment"
    t.date "payment_settlement"
    t.integer "profit_new", null: false
    t.integer "profit_settlement", null: false
    t.integer "valuation_new", null: false
    t.integer "valuation_settlement", null: false
    t.text "description"
    t.index ["customer_num"], name: "index_dmers_on_customer_num", unique: true
    t.index ["settlementer_id"], name: "index_dmers_on_settlementer_id"
    t.index ["store_prop_id"], name: "index_dmers_on_store_prop_id"
    t.index ["user_id"], name: "index_dmers_on_user_id"
  end

  create_table "n_results", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.date "date", null: false
    t.string "base", null: false
    t.string "area", null: false
    t.string "ojt"
    t.integer "profit", null: false
    t.integer "first_visit"
    t.integer "first_reply"
    t.integer "first_interview"
    t.integer "first_full_talk"
    t.integer "first_write"
    t.integer "first_get"
    t.integer "latter_visit"
    t.integer "latter_reply"
    t.integer "latter_interview"
    t.integer "latter_full_talk"
    t.integer "latter_write"
    t.integer "latter_get"
    t.integer "night_visit"
    t.integer "night_reply"
    t.integer "night_interview"
    t.integer "night_full_talk"
    t.integer "night_write"
    t.integer "night_get"
    t.integer "detached_a"
    t.integer "detached_get"
    t.integer "apartment_a"
    t.integer "apartment_get"
    t.integer "family_apartment_a"
    t.integer "family_apartment_get"
    t.integer "auto_single_a"
    t.integer "auto_single_get"
    t.integer "auto_family_a"
    t.integer "auto_family_get"
    t.integer "door_take"
    t.integer "easy"
    t.integer "auto_through_a"
    t.integer "auto_through_b"
    t.integer "close_soon"
    t.integer "existing_visit"
    t.integer "existing_interview"
    t.integer "existing_full_talk"
    t.integer "existing_get"
    t.integer "contract_change_interview"
    t.integer "contract_change_full_talk"
    t.integer "contract_change_get"
    t.integer "resum_payment_interview"
    t.integer "resum_payment_full_talk"
    t.integer "resum_payment_get"
    t.integer "transfer_get"
    t.integer "catch_call"
    t.integer "catch_interview"
    t.integer "catch_full_talk"
    t.integer "catch_get"
    t.integer "office_visit"
    t.integer "office_interview"
    t.integer "office_full_talk"
    t.integer "office_get"
    t.integer "terrestrial_new"
    t.integer "satellite_new"
    t.integer "account_new"
    t.integer "credit_new"
    t.integer "terrestrial_transfer"
    t.integer "satellite_transfer"
    t.integer "free_transfer"
    t.integer "contract_change"
    t.integer "resum_payment"
    t.integer "resum_payment_account"
    t.integer "resum_payment_credit"
    t.integer "resum_payment_num"
    t.integer "payment_change"
    t.integer "receipt_num"
    t.integer "receipt_account"
    t.integer "office"
    t.integer "no_watch_a"
    t.integer "no_watch_b"
    t.integer "no_watch_c"
    t.integer "no_watch_get"
    t.integer "not_everyone_a"
    t.integer "not_everyone_b"
    t.integer "not_everyone_c"
    t.integer "not_everyone_get"
    t.integer "throw_away_a"
    t.integer "throw_away_b"
    t.integer "throw_away_c"
    t.integer "throw_away_get"
    t.integer "suddenly_a"
    t.integer "suddenly_b"
    t.integer "suddenly_c"
    t.integer "suddenly_get"
    t.integer "another_contract_a"
    t.integer "another_contract_b"
    t.integer "another_contract_c"
    t.integer "another_contract_get"
    t.integer "no_thank_you_a"
    t.integer "no_thank_you_b"
    t.integer "no_thank_you_c"
    t.integer "no_thank_you_get"
    t.integer "late_night_a"
    t.integer "late_night_b"
    t.integer "late_night_c"
    t.integer "late_night_get"
    t.integer "busy_a"
    t.integer "busy_b"
    t.integer "busy_c"
    t.integer "busy_get"
    t.integer "do_it_a"
    t.integer "do_it_b"
    t.integer "do_it_c"
    t.integer "do_it_get"
    t.integer "think_a"
    t.integer "think_b"
    t.integer "think_c"
    t.integer "think_get"
    t.integer "partner_a"
    t.integer "partner_b"
    t.integer "partner_c"
    t.integer "partner_get"
    t.integer "company_a"
    t.integer "company_b"
    t.integer "company_c"
    t.integer "company_get"
    t.integer "student_a"
    t.integer "student_b"
    t.integer "student_c"
    t.integer "student_get"
    t.integer "no_money_a"
    t.integer "no_money_b"
    t.integer "no_money_c"
    t.integer "no_money_get"
    t.integer "not_here_a"
    t.integer "not_here_b"
    t.integer "not_here_c"
    t.integer "not_here_get"
    t.integer "no_payment_a"
    t.integer "no_payment_b"
    t.integer "no_payment_c"
    t.integer "no_payment_get"
    t.integer "foreign_a"
    t.integer "foreign_b"
    t.integer "foreign_c"
    t.integer "foreign_get"
    t.integer "difficult_deal_a"
    t.integer "difficult_deal_b"
    t.integer "difficult_deal_c"
    t.integer "difficult_deal_get"
    t.integer "past_trouble_a"
    t.integer "past_trouble_b"
    t.integer "past_trouble_c"
    t.integer "past_trouble_get"
    t.integer "trial_hope_a"
    t.integer "trial_hope_b"
    t.integer "trial_hope_c"
    t.integer "trial_hope_get"
    t.integer "other_a"
    t.integer "other_b"
    t.integer "other_c"
    t.integer "other_get"
    t.integer "no_tv_a"
    t.integer "no_tv_b"
    t.integer "no_tv_c"
    t.integer "no_tv_get"
    t.integer "no_tv_excavation"
    t.integer "no_tv_excavation_ng"
    t.integer "breaking_tv_a"
    t.integer "breaking_tv_b"
    t.integer "breaking_tv_c"
    t.integer "breaking_tv_get"
    t.integer "breaking_tv_excavation"
    t.integer "breaking_tv_excavation_ng"
    t.index ["user_id"], name: "index_n_results_on_user_id"
  end

  create_table "pandas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "grid_id"
    t.string "food_category", null: false
    t.string "client"
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "get_date", null: false
    t.string "ghost_flag"
    t.date "docu_sign_send"
    t.date "docu_sign_done"
    t.date "quality_check"
    t.date "delivery_arrangements"
    t.string "traning"
    t.date "result_point"
    t.date "payment"
    t.text "remarks"
    t.string "status"
    t.date "status_update"
    t.string "confirm_ball"
    t.date "confirm_date"
    t.string "confirmer"
    t.text "deficiency"
    t.text "deficiency_result"
    t.date "solution_date"
    t.integer "valuation_profit", null: false
    t.integer "actual_profit", null: false
    t.index ["grid_id"], name: "index_pandas_on_grid_id", unique: true
    t.index ["store_prop_id"], name: "index_pandas_on_store_prop_id"
    t.index ["user_id"], name: "index_pandas_on_user_id"
  end

  create_table "paypays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "client", null: false
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "date", null: false
    t.string "status", null: false
    t.date "status_update"
    t.date "payment"
    t.integer "profit", null: false
    t.integer "valuation", null: false
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
    t.index ["stock_id"], name: "index_pranesses_on_stock_id"
    t.index ["store_prop_id"], name: "index_pranesses_on_store_prop_id"
    t.index ["user_id"], name: "index_pranesses_on_user_id"
  end

  create_table "rakuten_casas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "femto_id"
    t.string "client"
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "date", null: false
    t.string "status", null: false
    t.date "status_update"
    t.string "confirm_method", null: false
    t.string "net_name", null: false
    t.string "hikari_collabo", null: false
    t.string "net_plan", null: false
    t.string "customer_num", null: false
    t.string "net_contracter", null: false
    t.string "error_status", null: false
    t.date "error_solution"
    t.date "payment"
    t.date "payment_put"
    t.integer "profit_new", null: false
    t.integer "profit_put", null: false
    t.integer "valuation_new", null: false
    t.integer "valuation_put", null: false
    t.text "description_error"
    t.text "description"
    t.index ["femto_id"], name: "index_rakuten_casas_on_femto_id", unique: true
    t.index ["store_prop_id"], name: "index_rakuten_casas_on_store_prop_id"
    t.index ["user_id"], name: "index_rakuten_casas_on_user_id"
  end

  create_table "results", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.date "date", null: false
    t.integer "profit"
    t.string "area", null: false
    t.string "shift", null: false
    t.string "ojt"
    t.integer "dmer"
    t.integer "dmer_settlement"
    t.integer "aupay"
    t.integer "aupay_settlement"
    t.integer "paypay"
    t.integer "panda"
    t.integer "praness"
    t.integer "summit"
    t.integer "rakuten_casa"
    t.integer "rakuten_casa_put"
    t.integer "first_visit", null: false
    t.integer "first_interview", null: false
    t.integer "first_full_talk", null: false
    t.integer "first_get", null: false
    t.integer "latter_visit", null: false
    t.integer "latter_interview", null: false
    t.integer "latter_full_talk", null: false
    t.integer "latter_get", null: false
    t.integer "cafe_visit"
    t.integer "cafe_interview"
    t.integer "cafe_full_talk"
    t.integer "cafe_get"
    t.integer "other_food_visit"
    t.integer "other_food_interview"
    t.integer "other_food_full_talk"
    t.integer "other_food_get"
    t.integer "car_visit"
    t.integer "car_interview"
    t.integer "car_full_talk"
    t.integer "car_get"
    t.integer "other_retail_visit"
    t.integer "other_retail_interview"
    t.integer "other_retail_full_talk"
    t.integer "other_retail_get"
    t.integer "hair_salon_visit"
    t.integer "hair_salon_interview"
    t.integer "hair_salon_full_talk"
    t.integer "hair_salon_get"
    t.integer "manipulative_visit"
    t.integer "manipulative_interview"
    t.integer "manipulative_full_talk"
    t.integer "manipulative_get"
    t.integer "other_service_visit"
    t.integer "other_service_interview"
    t.integer "other_service_full_talk"
    t.integer "other_service_get"
    t.integer "cashless_what_interview"
    t.integer "cashless_what_full_talk"
    t.integer "cashless_what_get"
    t.integer "cashless_who_interview"
    t.integer "cashless_who_full_talk"
    t.integer "cashless_who_get"
    t.integer "cashless_just_get_interview"
    t.integer "cashless_just_get_full_talk"
    t.integer "cashless_just_get_get"
    t.integer "cashless_paypay_only_interview"
    t.integer "cashless_paypay_only_full_talk"
    t.integer "cashless_paypay_only_get"
    t.integer "cashless_airpay_only_interview"
    t.integer "cashless_airpay_only_full_talk"
    t.integer "cashless_airpay_only_get"
    t.integer "cashless_card_only_interview"
    t.integer "cashless_card_only_full_talk"
    t.integer "cashless_card_only_get"
    t.integer "cashless_yet_interview"
    t.integer "cashless_yet_full_talk"
    t.integer "cashless_yet_get"
    t.integer "cashless_cash_only_interview"
    t.integer "cashless_cash_only_full_talk"
    t.integer "cashless_cash_only_get"
    t.integer "cashless_busy_interview"
    t.integer "cashless_busy_full_talk"
    t.integer "cashless_busy_get"
    t.integer "cashless_dull_interview"
    t.integer "cashless_dull_full_talk"
    t.integer "cashless_dull_get"
    t.integer "cashless_lack_info_interview"
    t.integer "cashless_lack_info_full_talk"
    t.integer "cashless_lack_info_get"
    t.integer "cashless_easy_interview"
    t.integer "cashless_easy_full_talk"
    t.integer "cashless_easy_get"
    t.integer "cashless_other_interview"
    t.integer "cashless_other_full_talk"
    t.integer "cashless_other_get"
    t.integer "summit_ng_detail"
    t.integer "summit_ng_cash"
    t.integer "summit_ng_building"
    t.integer "summit_reject_cash_interview"
    t.integer "summit_reject_cash_full_talk"
    t.integer "summit_reject_cash_get"
    t.integer "summit_busy_interview"
    t.integer "summit_busy_full_talk"
    t.integer "summit_busy_get"
    t.integer "summit_doubt_interview"
    t.integer "summit_doubt_full_talk"
    t.integer "summit_doubt_get"
    t.integer "summit_yet_interview"
    t.integer "summit_yet_full_talk"
    t.integer "summit_yet_get"
    t.integer "summit_not_change_interview"
    t.integer "summit_not_change_full_talk"
    t.integer "summit_not_change_get"
    t.integer "summit_other_interview"
    t.integer "summit_other_full_talk"
    t.integer "summit_other_get"
    t.integer "summit_easy_interview"
    t.integer "summit_easy_full_talk"
    t.integer "summit_easy_get"
    t.integer "panda_not_need_interview"
    t.integer "panda_not_need_full_talk"
    t.integer "panda_not_need_get"
    t.integer "panda_busy_interview"
    t.integer "panda_busy_full_talk"
    t.integer "panda_busy_get"
    t.integer "panda_yet_interview"
    t.integer "panda_yet_full_talk"
    t.integer "panda_yet_get"
    t.integer "panda_not_delivery_interview"
    t.integer "panda_not_delivery_full_talk"
    t.integer "panda_not_delivery_get"
    t.integer "panda_not_increment_interview"
    t.integer "panda_not_increment_full_talk"
    t.integer "panda_not_increment_get"
    t.integer "panda_not_margin_interview"
    t.integer "panda_not_margin_full_talk"
    t.integer "panda_not_margin_get"
    t.integer "panda_dull_interview"
    t.integer "panda_dull_full_talk"
    t.integer "panda_dull_get"
    t.integer "panda_lack_info_interview"
    t.integer "panda_lack_info_full_talk"
    t.integer "panda_lack_info_get"
    t.integer "panda_food_neko_interview"
    t.integer "panda_food_neko_full_talk"
    t.integer "panda_food_neko_get"
    t.integer "panda_other_interview"
    t.integer "panda_other_full_talk"
    t.integer "panda_other_get"
    t.integer "panda_easy_interview"
    t.integer "panda_easy_full_talk"
    t.integer "panda_easy_get"
    t.integer "casa_ng_lack_info"
    t.integer "casa_busy_interview"
    t.integer "casa_busy_full_talk"
    t.integer "casa_busy_get"
    t.integer "casa_dull_interview"
    t.integer "casa_dull_full_talk"
    t.integer "casa_dull_get"
    t.integer "casa_not_put_space_interview"
    t.integer "casa_not_put_space_full_talk"
    t.integer "casa_not_put_space_get"
    t.integer "casa_no_merit_interview"
    t.integer "casa_no_merit_full_talk"
    t.integer "casa_no_merit_get"
    t.integer "casa_distrust_interview"
    t.integer "casa_distrust_full_talk"
    t.integer "casa_distrust_get"
    t.integer "casa_not_use_net_interview"
    t.integer "casa_not_use_net_full_talk"
    t.integer "casa_not_use_net_get"
    t.integer "casa_not_need_interview"
    t.integer "casa_not_need_full_talk"
    t.integer "casa_not_need_get"
    t.integer "casa_easy_interview"
    t.integer "casa_easy_full_talk"
    t.integer "casa_easy_get"
    t.integer "casa_other_interview"
    t.integer "casa_other_full_talk"
    t.integer "casa_other_get"
    t.index ["user_id"], name: "index_results_on_user_id"
  end

  create_table "return_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "stock_id"
    t.date "return"
    t.index ["stock_id"], name: "index_return_histories_on_stock_id"
    t.index ["user_id"], name: "index_return_histories_on_user_id"
  end

  create_table "shifts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "year", null: false
    t.integer "month", null: false
    t.integer "house_work", null: false
    t.integer "ojt", null: false
    t.integer "cashless_new", null: false
    t.integer "n", null: false
    t.integer "cashless_settlement", null: false
    t.integer "praness", null: false
    t.integer "summit", null: false
    t.integer "panda", null: false
    t.integer "rakuten_casa", null: false
    t.integer "rakuten_casa_put", null: false
    t.integer "goal", null: false
    t.index ["user_id"], name: "index_shifts_on_user_id"
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
    t.string "mac_num"
    t.string "status"
    t.string "mail"
    t.text "remarks"
    t.index ["stock_num"], name: "index_stocks_on_stock_num", unique: true
  end

  create_table "store_props", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "race", null: false
    t.string "name", null: false
    t.string "industry", null: false
    t.string "head_store"
    t.string "corporate_name"
    t.string "corporate_address"
    t.integer "corporate_num"
    t.string "person_main_name", null: false
    t.string "person_main_kana", null: false
    t.string "person_main_class", null: false
    t.date "person_main_birthday"
    t.string "person_sub_name"
    t.string "person_sub_kana"
    t.string "person_sub_class"
    t.date "person_sub_birthday"
    t.string "phone_number_1", null: false
    t.string "phone_number_2"
    t.string "mail_1", null: false
    t.string "mail_2"
    t.string "prefecture", null: false
    t.string "city", null: false
    t.string "municipalities", null: false
    t.string "address", null: false
    t.string "building_name"
    t.string "suitable_time"
    t.string "holiday"
    t.string "description"
    t.index ["name"], name: "index_store_props_on_name", unique: true
  end

  create_table "summit_customer_props", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "customer_num", null: false
    t.string "client", null: false
    t.bigint "store_prop_id"
    t.string "claim_house", null: false
    t.string "claim_address", null: false
    t.string "contract_name", null: false
    t.string "before_electric"
    t.index ["customer_num"], name: "index_summit_customer_props_on_customer_num", unique: true
    t.index ["store_prop_id"], name: "index_summit_customer_props_on_store_prop_id"
  end

  create_table "summits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "summit_customer_prop_id"
    t.bigint "user_id"
    t.date "get_date", null: false
    t.integer "payment"
    t.string "status", null: false
    t.date "status_update"
    t.string "supply_num", null: false
    t.string "contract_num"
    t.string "menu", null: false
    t.string "plan"
    t.string "contract_type"
    t.integer "contract_cap"
    t.string "contract_cap_unit"
    t.integer "amount_use"
    t.date "start"
    t.integer "profit"
    t.integer "profit_expected"
    t.string "remarks"
    t.string "power_company"
    t.index ["summit_customer_prop_id"], name: "index_summits_on_summit_customer_prop_id"
    t.index ["user_id"], name: "index_summits_on_user_id"
  end

  create_table "trouble_ns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "base", null: false
    t.date "date", null: false
    t.string "category", null: false
    t.string "customer_name", null: false
    t.string "get_status", null: false
    t.string "contract_type", null: false
    t.bigint "user_id"
    t.string "confirmer"
    t.string "customer_caller", null: false
    t.string "content_type", null: false
    t.text "customer_opinion"
    t.text "user_opinion"
    t.text "result"
    t.index ["user_id"], name: "index_trouble_ns_on_user_id"
  end

  create_table "trouble_sses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "store_prop_id"
    t.string "category", null: false
    t.string "customer_name", null: false
    t.string "get_status", null: false
    t.string "product", null: false
    t.bigint "user_id"
    t.string "confirmer", null: false
    t.string "content_type", null: false
    t.text "customer_opinion", null: false
    t.date "contact_date"
    t.text "result"
    t.text "remarks"
    t.index ["store_prop_id"], name: "index_trouble_sses_on_store_prop_id"
    t.index ["user_id"], name: "index_trouble_sses_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "base"
    t.string "base_sub"
    t.string "position"
    t.string "position_sub"
    t.string "group"
    t.string "team"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "aupays", "store_props"
  add_foreign_key "aupays", "users"
  add_foreign_key "aupays", "users", column: "settlementer_id"
  add_foreign_key "dmers", "store_props"
  add_foreign_key "dmers", "users"
  add_foreign_key "dmers", "users", column: "settlementer_id"
  add_foreign_key "n_results", "users"
  add_foreign_key "pandas", "store_props"
  add_foreign_key "pandas", "users"
  add_foreign_key "paypays", "store_props"
  add_foreign_key "paypays", "users"
  add_foreign_key "pranesses", "stocks"
  add_foreign_key "pranesses", "store_props"
  add_foreign_key "pranesses", "users"
  add_foreign_key "rakuten_casas", "store_props"
  add_foreign_key "rakuten_casas", "users"
  add_foreign_key "results", "users"
  add_foreign_key "return_histories", "stocks"
  add_foreign_key "return_histories", "users"
  add_foreign_key "shifts", "users"
  add_foreign_key "stock_histories", "stocks"
  add_foreign_key "stock_histories", "users"
  add_foreign_key "summit_customer_props", "store_props"
  add_foreign_key "summits", "summit_customer_props"
  add_foreign_key "summits", "users"
  add_foreign_key "trouble_ns", "users"
  add_foreign_key "trouble_sses", "store_props"
  add_foreign_key "trouble_sses", "users"
end
