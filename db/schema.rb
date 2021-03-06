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

ActiveRecord::Schema.define(version: 2022_07_15_112932) do

  create_table "airpays", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "store_name", null: false
    t.bigint "user_id"
    t.string "race"
    t.string "corporate_name"
    t.date "date", null: false
    t.string "status", null: false
    t.string "terminal_status"
    t.string "customer_num", null: false
    t.date "result_point"
    t.integer "payment"
    t.string "ipad_flag", null: false
    t.integer "vm_status", null: false
    t.integer "vm_status_name", null: false
    t.integer "doc_follow"
    t.date "shipping"
    t.string "delivery_status"
    t.integer "valuation", null: false
    t.integer "profit", null: false
    t.index ["user_id"], name: "index_airpays_on_user_id"
  end

  create_table "aupays", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "customer_num"
    t.string "client"
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "date", null: false
    t.date "share"
    t.string "status", null: false
    t.date "status_update"
    t.bigint "settlementer_id"
    t.date "shipment"
    t.date "settlement"
    t.date "picture"
    t.date "settlement_deadline"
    t.string "status_settlement"
    t.date "status_update_settlement"
    t.date "payment"
    t.date "payment_settlement"
    t.date "result_point"
    t.date "result_point_settlement"
    t.date "deficiency"
    t.date "deficiency_settlement"
    t.date "deficiency_solution"
    t.date "deficiency_solution_settlement"
    t.date "deficiency_deadline"
    t.text "deficiency_remarks"
    t.text "deficiency_remarks_settlement"
    t.text "description"
    t.integer "profit_new", null: false
    t.integer "profit_settlement", null: false
    t.integer "valuation_new", null: false
    t.integer "valuation_settlement", null: false
    t.index ["settlementer_id"], name: "index_aupays_on_settlementer_id"
    t.index ["store_prop_id"], name: "index_aupays_on_store_prop_id", unique: true
    t.index ["user_id"], name: "index_aupays_on_user_id"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "store_prop_id"
    t.string "product", null: false
    t.string "content", null: false
    t.string "status", null: false
    t.string "ball"
    t.date "request"
    t.text "request_show"
    t.date "response"
    t.text "response_show"
    t.date "done"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["store_prop_id"], name: "index_comments_on_store_prop_id"
  end

  create_table "costs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "month", null: false
    t.string "base", null: false
    t.string "group", null: false
    t.integer "sales_man", null: false
    t.integer "office_worker", null: false
    t.integer "administrator", null: false
    t.integer "social_insurance", null: false
    t.integer "sales_man_cost", null: false
    t.integer "office_worker_cost", null: false
    t.integer "office", null: false
    t.integer "dorm", null: false
    t.integer "utility_net_cost", null: false
    t.integer "bonus_stock", null: false
    t.integer "travel_stock", null: false
    t.integer "other", null: false
    t.date "update_date"
  end

  create_table "display_periods", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.date "start_period_01"
    t.date "end_period_01"
    t.date "start_period_02"
    t.date "end_period_02"
    t.date "start_period_03"
    t.date "end_period_03"
    t.date "start_period_04"
    t.date "end_period_04"
    t.date "start_period_05"
    t.date "end_period_05"
  end

  create_table "dmers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "customer_num"
    t.string "client", null: false
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "date", null: false
    t.date "share"
    t.string "industry_status"
    t.string "status", null: false
    t.date "status_update"
    t.bigint "settlementer_id"
    t.date "shipment"
    t.date "settlement"
    t.date "settlement_second"
    t.date "picture"
    t.date "settlement_deadline"
    t.string "status_settlement"
    t.date "status_update_settlement"
    t.date "payment"
    t.date "payment_settlement"
    t.date "result_point"
    t.date "result_point_settlement"
    t.date "deficiency"
    t.date "deficiency_settlement"
    t.date "deficiency_solution"
    t.date "deficiency_solution_settlement"
    t.date "deficiency_deadline"
    t.text "deficiency_remarks"
    t.text "deficiency_remarks_settlement"
    t.text "description"
    t.integer "profit_new", null: false
    t.integer "profit_settlement", null: false
    t.integer "profit_second_settlement", null: false
    t.integer "valuation_new", null: false
    t.integer "valuation_settlement", null: false
    t.integer "valuation_second_settlement", null: false
    t.index ["settlementer_id"], name: "index_dmers_on_settlementer_id"
    t.index ["store_prop_id"], name: "index_dmers_on_store_prop_id", unique: true
    t.index ["user_id"], name: "index_dmers_on_user_id"
  end

  create_table "n_results", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
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

  create_table "pandas", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
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
    t.index ["store_prop_id"], name: "index_pandas_on_store_prop_id"
    t.index ["user_id"], name: "index_pandas_on_user_id"
  end

  create_table "paypays", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "customer_num"
    t.string "client", null: false
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "date", null: false
    t.string "status", null: false
    t.date "status_update"
    t.date "deficiency"
    t.date "deficiency_solution"
    t.date "payment"
    t.text "remarks"
    t.date "result_point"
    t.integer "profit", null: false
    t.integer "valuation", null: false
    t.index ["store_prop_id"], name: "index_paypays_on_store_prop_id", unique: true
    t.index ["user_id"], name: "index_paypays_on_user_id"
  end

  create_table "pranesses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
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

  create_table "product_checkers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "store_name"
    t.string "tel1"
    t.string "tel2"
    t.string "mail1"
    t.string "mail2"
    t.string "mail3"
    t.string "product1"
    t.string "product2"
    t.string "product3"
    t.string "product4"
    t.string "product5"
    t.string "product6"
    t.string "product7"
    t.string "product8"
    t.string "product9"
    t.string "product10"
  end

  create_table "rakuten_casas", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "client", null: false
    t.string "client_num"
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "date", null: false
    t.string "status", null: false
    t.date "status_update"
    t.string "net_confirm_method", null: false
    t.string "net_name", null: false
    t.string "hikari_collabo", null: false
    t.string "net_plan", null: false
    t.string "customer_num", null: false
    t.string "net_address", null: false
    t.string "net_contracter", null: false
    t.string "net_contracter_kana", null: false
    t.string "net_phone_number", null: false
    t.date "result_point"
    t.text "remarks"
    t.date "share"
    t.date "deficiency"
    t.string "status_deficiency"
    t.date "deficiency_solution"
    t.text "deficiency_remarks"
    t.date "deficiency_net"
    t.string "status_deficiency_net"
    t.date "deficiency_share_net"
    t.date "deficiency_request_net"
    t.date "deficiency_last_shared_net"
    t.text "deficiency_result_net"
    t.date "deficiency_solution_net"
    t.text "deficiency_remarks_net"
    t.date "deficiency_anti"
    t.string "status_deficiency_anti"
    t.date "deficiency_share_anti"
    t.date "deficiency_request_anti"
    t.date "deficiency_last_shared_anti"
    t.text "deficiency_result_anti"
    t.text "deficiency_remarks_anti"
    t.date "deficiency_solution_anti"
    t.date "call_date"
    t.string "call_status"
    t.text "call_remark"
    t.date "order"
    t.date "arrival"
    t.string "femto_id"
    t.string "femto_serial"
    t.string "inspection"
    t.date "done_oss"
    t.date "put_plan"
    t.date "put"
    t.bigint "putter_id"
    t.string "radio_waves"
    t.date "google_form_share"
    t.string "status_put"
    t.date "share_book"
    t.string "status_book"
    t.date "deficiency_book"
    t.text "deficiency_remarks_book"
    t.text "deficiency_result_book"
    t.date "deficiency_solution_book"
    t.date "done_book"
    t.date "share_undone_book"
    t.string "status_undone_book"
    t.date "deficiency_solution_undone_book"
    t.date "done_undone_book"
    t.string "radio_waves_undone"
    t.date "put_adjustment"
    t.bigint "adjustmenter_id"
    t.date "share_adjustment"
    t.date "deficiency_adjustment"
    t.date "deficiency_solution_adjustment"
    t.date "google_form_share_adjustment"
    t.string "adjustment_status"
    t.date "done_adjustment"
    t.date "share_app"
    t.date "app_create"
    t.string "status_app"
    t.date "done_app"
    t.date "share_memo"
    t.date "memo_create"
    t.string "status_memo"
    t.date "done_memo"
    t.string "letter_pack_num1"
    t.string "letter_pack_num2"
    t.date "payment"
    t.date "payment_put"
    t.integer "profit_new", null: false
    t.integer "profit_put", null: false
    t.integer "valuation_new", null: false
    t.integer "valuation_put", null: false
    t.index ["adjustmenter_id"], name: "index_rakuten_casas_on_adjustmenter_id"
    t.index ["putter_id"], name: "index_rakuten_casas_on_putter_id"
    t.index ["store_prop_id"], name: "index_rakuten_casas_on_store_prop_id", unique: true
    t.index ["user_id"], name: "index_rakuten_casas_on_user_id"
  end

  create_table "rakuten_pays", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "client", null: false
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "date", null: false
    t.date "share"
    t.string "status", null: false
    t.string "transcript"
    t.string "customer_num"
    t.date "status_update"
    t.date "deficiency"
    t.date "deficiency_solution"
    t.text "deficiency_info"
    t.text "deficiency_consent"
    t.date "result_point"
    t.date "payment"
    t.integer "profit", null: false
    t.integer "valuation", null: false
    t.index ["store_prop_id"], name: "index_rakuten_pays_on_store_prop_id", unique: true
    t.index ["user_id"], name: "index_rakuten_pays_on_user_id"
  end

  create_table "result_casas", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "result_id"
    t.integer "ng_01"
    t.integer "ng_02"
    t.integer "ng_03"
    t.integer "out_interview_01"
    t.integer "out_full_talk_01"
    t.integer "out_get_01"
    t.integer "out_interview_02"
    t.integer "out_full_talk_02"
    t.integer "out_get_02"
    t.integer "out_interview_03"
    t.integer "out_full_talk_03"
    t.integer "out_get_03"
    t.integer "out_interview_04"
    t.integer "out_full_talk_04"
    t.integer "out_get_04"
    t.integer "out_interview_05"
    t.integer "out_full_talk_05"
    t.integer "out_get_05"
    t.integer "out_interview_06"
    t.integer "out_full_talk_06"
    t.integer "out_get_06"
    t.integer "out_interview_07"
    t.integer "out_full_talk_07"
    t.integer "out_get_07"
    t.integer "out_interview_08"
    t.integer "out_full_talk_08"
    t.integer "out_get_08"
    t.integer "out_interview_09"
    t.integer "out_full_talk_09"
    t.integer "out_get_09"
    t.integer "out_interview_10"
    t.integer "out_full_talk_10"
    t.integer "out_get_10"
    t.integer "out_interview_11"
    t.integer "out_full_talk_11"
    t.integer "out_get_11"
    t.integer "out_interview_12"
    t.integer "out_full_talk_12"
    t.integer "out_get_12"
    t.integer "out_interview_13"
    t.integer "out_full_talk_13"
    t.integer "out_get_13"
    t.integer "out_interview_14"
    t.integer "out_full_talk_14"
    t.integer "out_get_14"
    t.integer "out_interview_15"
    t.integer "out_full_talk_15"
    t.integer "out_get_15"
    t.integer "out_interview_16"
    t.integer "out_full_talk_16"
    t.integer "out_get_16"
    t.integer "out_interview_17"
    t.integer "out_full_talk_17"
    t.integer "out_get_17"
    t.integer "out_interview_18"
    t.integer "out_full_talk_18"
    t.integer "out_get_18"
    t.integer "out_interview_19"
    t.integer "out_full_talk_19"
    t.integer "out_get_19"
    t.integer "out_interview_20"
    t.integer "out_full_talk_20"
    t.integer "out_get_20"
    t.index ["result_id"], name: "index_result_casas_on_result_id"
  end

  create_table "result_cashes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "result_id"
    t.integer "ng_01"
    t.integer "ng_02"
    t.integer "ng_03"
    t.integer "out_interview_01"
    t.integer "out_full_talk_01"
    t.integer "out_get_01"
    t.integer "out_interview_02"
    t.integer "out_full_talk_02"
    t.integer "out_get_02"
    t.integer "out_interview_03"
    t.integer "out_full_talk_03"
    t.integer "out_get_03"
    t.integer "out_interview_04"
    t.integer "out_full_talk_04"
    t.integer "out_get_04"
    t.integer "out_interview_05"
    t.integer "out_full_talk_05"
    t.integer "out_get_05"
    t.integer "out_interview_06"
    t.integer "out_full_talk_06"
    t.integer "out_get_06"
    t.integer "out_interview_07"
    t.integer "out_full_talk_07"
    t.integer "out_get_07"
    t.integer "out_interview_08"
    t.integer "out_full_talk_08"
    t.integer "out_get_08"
    t.integer "out_interview_09"
    t.integer "out_full_talk_09"
    t.integer "out_get_09"
    t.integer "out_interview_10"
    t.integer "out_full_talk_10"
    t.integer "out_get_10"
    t.integer "out_interview_11"
    t.integer "out_full_talk_11"
    t.integer "out_get_11"
    t.integer "out_interview_12"
    t.integer "out_full_talk_12"
    t.integer "out_get_12"
    t.integer "out_interview_13"
    t.integer "out_full_talk_13"
    t.integer "out_get_13"
    t.integer "out_interview_14"
    t.integer "out_full_talk_14"
    t.integer "out_get_14"
    t.integer "out_interview_15"
    t.integer "out_full_talk_15"
    t.integer "out_get_15"
    t.integer "out_interview_16"
    t.integer "out_full_talk_16"
    t.integer "out_get_16"
    t.integer "out_interview_17"
    t.integer "out_full_talk_17"
    t.integer "out_get_17"
    t.integer "out_interview_18"
    t.integer "out_full_talk_18"
    t.integer "out_get_18"
    t.integer "out_interview_19"
    t.integer "out_full_talk_19"
    t.integer "out_get_19"
    t.integer "out_interview_20"
    t.integer "out_full_talk_20"
    t.integer "out_get_20"
    t.integer "dmer"
    t.integer "aupay"
    t.integer "paypay"
    t.integer "rakuten_pay"
    t.index ["result_id"], name: "index_result_cashes_on_result_id"
  end

  create_table "result_sales", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "year", null: false
    t.integer "month", null: false
    t.integer "valuation", null: false
    t.integer "profit", null: false
    t.string "product"
    t.index ["user_id"], name: "index_result_sales_on_user_id"
  end

  create_table "result_summits", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "result_id"
    t.integer "ng_01"
    t.integer "ng_02"
    t.integer "ng_03"
    t.integer "out_interview_01"
    t.integer "out_full_talk_01"
    t.integer "out_get_01"
    t.integer "out_interview_02"
    t.integer "out_full_talk_02"
    t.integer "out_get_02"
    t.integer "out_interview_03"
    t.integer "out_full_talk_03"
    t.integer "out_get_03"
    t.integer "out_interview_04"
    t.integer "out_full_talk_04"
    t.integer "out_get_04"
    t.integer "out_interview_05"
    t.integer "out_full_talk_05"
    t.integer "out_get_05"
    t.integer "out_interview_06"
    t.integer "out_full_talk_06"
    t.integer "out_get_06"
    t.integer "out_interview_07"
    t.integer "out_full_talk_07"
    t.integer "out_get_07"
    t.integer "out_interview_08"
    t.integer "out_full_talk_08"
    t.integer "out_get_08"
    t.integer "out_interview_09"
    t.integer "out_full_talk_09"
    t.integer "out_get_09"
    t.integer "out_interview_10"
    t.integer "out_full_talk_10"
    t.integer "out_get_10"
    t.integer "out_interview_11"
    t.integer "out_full_talk_11"
    t.integer "out_get_11"
    t.integer "out_interview_12"
    t.integer "out_full_talk_12"
    t.integer "out_get_12"
    t.integer "out_interview_13"
    t.integer "out_full_talk_13"
    t.integer "out_get_13"
    t.integer "out_interview_14"
    t.integer "out_full_talk_14"
    t.integer "out_get_14"
    t.integer "out_interview_15"
    t.integer "out_full_talk_15"
    t.integer "out_get_15"
    t.integer "out_interview_16"
    t.integer "out_full_talk_16"
    t.integer "out_get_16"
    t.integer "out_interview_17"
    t.integer "out_full_talk_17"
    t.integer "out_get_17"
    t.integer "out_interview_18"
    t.integer "out_full_talk_18"
    t.integer "out_get_18"
    t.integer "out_interview_19"
    t.integer "out_full_talk_19"
    t.integer "out_get_19"
    t.integer "out_interview_20"
    t.integer "out_full_talk_20"
    t.integer "out_get_20"
    t.index ["result_id"], name: "index_result_summits_on_result_id"
  end

  create_table "results", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "user_id"
    t.date "date", null: false
    t.string "area", null: false
    t.string "shift", null: false
    t.bigint "ojt_id"
    t.integer "first_visit"
    t.integer "first_interview"
    t.integer "first_full_talk"
    t.integer "first_get"
    t.integer "latter_visit"
    t.integer "latter_interview"
    t.integer "latter_full_talk"
    t.integer "latter_get"
    t.integer "cafe_visit"
    t.integer "cafe_get"
    t.integer "other_food_visit"
    t.integer "other_food_get"
    t.integer "car_visit"
    t.integer "car_get"
    t.integer "other_retail_visit"
    t.integer "other_retail_get"
    t.integer "hair_salon_visit"
    t.integer "hair_salon_get"
    t.integer "manipulative_visit"
    t.integer "manipulative_get"
    t.integer "other_service_visit"
    t.integer "other_service_get"
    t.integer "profit"
    t.integer "first_total_visit"
    t.integer "latter_total_visit"
    t.integer "visit10"
    t.integer "visit11"
    t.integer "visit12"
    t.integer "visit13"
    t.integer "visit14"
    t.integer "visit15"
    t.integer "visit16"
    t.integer "visit17"
    t.integer "visit18"
    t.integer "visit19"
    t.integer "visit20"
    t.integer "get10"
    t.integer "get11"
    t.integer "get12"
    t.integer "get13"
    t.integer "get14"
    t.integer "get15"
    t.integer "get16"
    t.integer "get17"
    t.integer "get18"
    t.integer "get19"
    t.integer "get20"
    t.string "product"
    t.index ["ojt_id"], name: "index_results_on_ojt_id"
    t.index ["user_id"], name: "index_results_on_user_id"
  end

  create_table "return_histories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "stock_id"
    t.date "return"
    t.index ["stock_id"], name: "index_return_histories_on_stock_id"
    t.index ["user_id"], name: "index_return_histories_on_user_id"
  end

  create_table "shifts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "start_time"
    t.string "shift"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_shifts_on_user_id"
  end

  create_table "st_insurances", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "client", null: false
    t.bigint "user_id"
    t.bigint "store_prop_id"
    t.date "date", null: false
    t.string "status", null: false
    t.date "status_update"
    t.date "deficiency"
    t.date "deficiency_solution"
    t.date "payment"
    t.text "remarks"
    t.date "result_point"
    t.integer "profit", null: false
    t.integer "valuation", null: false
    t.index ["store_prop_id"], name: "index_st_insurances_on_store_prop_id"
    t.index ["user_id"], name: "index_st_insurances_on_user_id"
  end

  create_table "stock_histories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "stock_id"
    t.date "take_out"
    t.index ["stock_id"], name: "index_stock_histories_on_stock_id"
    t.index ["user_id"], name: "index_stock_histories_on_user_id"
  end

  create_table "stocks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "stock_num", null: false
    t.string "mac_num"
    t.string "status"
    t.string "mail"
    t.text "remarks"
    t.index ["stock_num"], name: "index_stocks_on_stock_num", unique: true
  end

  create_table "store_props", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "race"
    t.string "name", limit: 255, collation: "utf8mb4_bin"
    t.string "industry"
    t.string "head_store"
    t.string "corporate_name"
    t.text "corporate_address"
    t.string "corporate_num"
    t.string "gender_main", null: false
    t.string "person_main_name", null: false
    t.string "person_main_kana", null: false
    t.string "person_main_class"
    t.date "person_main_birthday"
    t.string "gender_sub"
    t.string "person_sub_name"
    t.string "person_sub_kana"
    t.string "person_sub_class"
    t.date "person_sub_birthday"
    t.string "phone_number_1", null: false
    t.string "phone_number_2"
    t.string "mail_1"
    t.string "mail_2"
    t.string "prefecture", null: false
    t.string "city", null: false
    t.string "municipalities", null: false
    t.string "address", null: false
    t.string "building_name"
    t.string "suitable_time"
    t.string "holiday"
    t.string "description"
  end

  create_table "summit_customer_props", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "customer_num", null: false
    t.string "client", null: false
    t.bigint "store_prop_id"
    t.string "claim_house", null: false
    t.string "claim_address", null: false
    t.string "contract_name", null: false
    t.string "before_electric"
    t.index ["store_prop_id"], name: "index_summit_customer_props_on_store_prop_id"
  end

  create_table "summits", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
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

  create_table "trouble_ns", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
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

  create_table "trouble_sses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
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

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
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

  add_foreign_key "airpays", "users"
  add_foreign_key "aupays", "store_props"
  add_foreign_key "aupays", "users"
  add_foreign_key "aupays", "users", column: "settlementer_id"
  add_foreign_key "comments", "store_props"
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
  add_foreign_key "rakuten_casas", "users", column: "adjustmenter_id"
  add_foreign_key "rakuten_casas", "users", column: "putter_id"
  add_foreign_key "rakuten_pays", "store_props"
  add_foreign_key "rakuten_pays", "users"
  add_foreign_key "result_casas", "results"
  add_foreign_key "result_cashes", "results"
  add_foreign_key "result_sales", "users"
  add_foreign_key "result_summits", "results"
  add_foreign_key "results", "users"
  add_foreign_key "return_histories", "stocks"
  add_foreign_key "return_histories", "users"
  add_foreign_key "shifts", "users"
  add_foreign_key "st_insurances", "store_props"
  add_foreign_key "st_insurances", "users"
  add_foreign_key "stock_histories", "stocks"
  add_foreign_key "stock_histories", "users"
  add_foreign_key "summit_customer_props", "store_props"
  add_foreign_key "summits", "summit_customer_props"
  add_foreign_key "summits", "users"
  add_foreign_key "trouble_ns", "users"
  add_foreign_key "trouble_sses", "store_props"
  add_foreign_key "trouble_sses", "users"
end
