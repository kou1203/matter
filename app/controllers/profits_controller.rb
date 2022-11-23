class ProfitsController < ApplicationController
  before_action :authenticate_user!
  before_action :back_retirement, only: [:index]
  require 'google_drive'
  def index
    # controllers/application_controller.rbから参照
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @calc_periods = CalcPeriod.where(sales_category: "実売")
    profit_pack # 実売の計算式が入った関数
  end 

  def profit_export_by_spreadsheet
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @calc_periods = CalcPeriod.where(sales_category: "実売")
    profit_pack # 実売の計算式が入った関数
    # GoogleDriveのセッションを取得する
    @session = GoogleDrive::Session.from_config("config.json")
    @chubu_session = @session.spreadsheet_by_key("1Cz5Bzdsc1er2H6TbdiiLRRdcQVeoAb6ApQ6a8-K5An4").worksheet_by_title("中部利益表")
    @kansai_session = @session.spreadsheet_by_key("1Cz5Bzdsc1er2H6TbdiiLRRdcQVeoAb6ApQ6a8-K5An4").worksheet_by_title("関西利益表")
    @kanto_session = @session.spreadsheet_by_key("1Cz5Bzdsc1er2H6TbdiiLRRdcQVeoAb6ApQ6a8-K5An4").worksheet_by_title("関東利益表")
    @kyushu_session = @session.spreadsheet_by_key("1Cz5Bzdsc1er2H6TbdiiLRRdcQVeoAb6ApQ6a8-K5An4").worksheet_by_title("九州利益表")
    @session_ary = [@chubu_session,@kansai_session,@kanto_session,@kyushu_session]
    # 書き込むシートを指定する
    # スプレッドシートへの書き込み
    # @sheets[1, 1] = "Hello World"
      @cash_ary.zip(@session_ary) do |base, session|
        index_cnt = 4
        out_index = 12 + (base.length * 2)
        base.each do |user|
          base_profit_by_spread(session,user,index_cnt)
          base_out_by_spread(session,user,out_index)
          index_cnt += 1
          out_index += 1
        end
        session.save
      end

      @calc_periods_len = CalcPeriod.where(sales_category: "評価売")
      @users_ary = [@users_chubu_len, @users_kansai_len, @users_kanto_len,@users_kyushu_len]
      valuation_pack
      @cash_ary.zip(@session_ary) do |base, session|
        index_cnt = 8 + base.length
        base.each do |user|
          base_profit_by_spread(session,user,index_cnt)
          index_cnt += 1
        end
        session.save
      end
  end

  def sum_export 
    profit_pack # 実売の計算式が入った関数
    head :no_content
    filename = "#{@end_date.month}月合計実売"
    columns_ja = ["拠点", "実売Ave","現状実売","終着実売"]
    columns = ["base","profit_ave","profit","profit_fin"]
    bom = "\uFEFF"
    all_ave = 0
    csv = CSV.generate(bom) do |csv|
      csv << columns_ja
      result_attributes = {}
      @base_list.each do |base|
        base_fin = base.sum { |hash| hash["合計終着"] } rescue 0
        base_shift = base.sum { |hash| hash["予定シフト"] } rescue 0
        base_ave = (base_fin.to_f / base_shift).round() rescue 0
        if (base[0]["拠点"] == "中部SS") || (base[0]["拠点"] == "関西SS") || (base[0]["拠点"] == "関東SS")
          all_ave += base_ave
        end
        result_attributes["base"] = base[0]["拠点"]
        result_attributes["profit_ave"] = base_ave
        result_attributes["profit"] = base.sum { |hash| hash["合計現状売上"]}
        result_attributes["profit_fin"] = base_fin 

        csv << result_attributes.values_at(*columns)
      end 
      result_attributes["base"] = "全拠点"
      result_attributes["profit_ave"] = all_ave
      result_attributes["profit"] = @all_list.sum { |hash| hash["合計現状売上"] }
      result_attributes["profit_fin"] = @all_list.sum { |hash| hash["合計終着"] }
      csv << result_attributes.values_at(*columns)
    end 
    create_csv(filename,csv)
  end 

  def index_export 
    profit_pack # 実売の計算式が入った関数
    head :no_content
    filename = "#{@end_date.month}月個別実売資料"
    columns_ja = [
      "拠点","ユーザー", "キャッシュ1日Ave","新規売上","決済売上","現状売上",
      "新規終着","決済終着","終着売上","新規予定","決済予定","予定シフト",
      "新規消化","決済消化","消化シフト","残シフト","帯同シフト",
      "dメル成果1","dメル成果2","dメル成果3","auPay成果","PayPay成果",
      "楽天ペイ成果","AirPay成果","出前館成果", "auステッカー成果",
      "訪問","応答","応答率","対面","対面率","フルトーク","フルトーク率","成約","成約率",
      "０１：どうゆうこと？：対面","０１：どうゆうこと？：フル","０１：どうゆうこと？：フル率","０１：どうゆうこと？：成約","０１：どうゆうこと？：成約率",
      "０２：君は誰？協会？：対面","０２：君は誰？協会？：フル","０２：君は誰？協会？：フル率","０２：君は誰？協会？：成約","０２：君は誰？協会？：成約率",
      "０３：もらうだけでいいの？：対面","０３：もらうだけでいいの？：フル","０３：もらうだけでいいの？：フル率","０３：もらうだけでいいの？：成約","０３：もらうだけでいいの？：成約率",
      "０４：PayPayのみ：対面","０４：PayPayのみ：フル","０４：PayPayのみ：フル率","０４：PayPayのみ：成約","０４：PayPayのみ：成約率",
      "０５：AirPayのみ：対面","０５：AirPayのみ：フル","０５：AirPayのみ：フル率","０５：AirPayのみ：成約","０５：AirPayのみ：成約率",
      "０６：カードのみ：対面","０６：カードのみ：フル","０６：カードのみ：フル率","０６：カードのみ：成約","０６：カードのみ：成約率",
      "０７：先延ばし：対面","０７：先延ばし：フル","０７：先延ばし：フル率","０７：先延ばし：成約","０７：先延ばし：成約率",
      "０８：現金のみ：対面","０８：現金のみ：フル","０８：現金のみ：フル率","０８：現金のみ：成約","０８：現金のみ：成約率",
      "０９：忙しい：対面","０９：忙しい：フル","０９：忙しい：フル率","０９：忙しい：成約","０９：忙しい：成約率",
      "１０：面倒くさい：対面","１０：面倒くさい：フル","１０：面倒くさい：フル率","１０：面倒くさい：成約","１０：面倒くさい：成約率",
      "１１：情報不足：対面","１１：情報不足：フル","１１：情報不足：フル率","１１：情報不足：成約","１１：情報不足：成約率",
      "１２：ペロ：対面","１２：ペロ：フル","１２：ペロ：フル率","１２：ペロ：成約","１２：ペロ：成約率",
      "１３：その他：対面","１３：その他：フル","１３：その他：フル率","１３：その他：成約","１３：その他：成約率",
      "喫茶・カフェ訪問数","喫茶・カフェ獲得数","その他飲食訪問数","その他飲食獲得数","車屋訪問数","車屋獲得数","その他小売訪問数","その他小売獲得数",
      "理容・美容訪問数","理容・美容獲得数","整体・鍼灸訪問数","整体・鍼灸獲得数","その他サービス訪問数","その他サービス獲得数",
      "dメル獲得数","dメルアクセプタンス数","dメル2回目決済数","auPay獲得数","auPayアクセプタンス数",
      "PayPay獲得数","楽天ペイ獲得数","AirPay獲得数"
    ]
    columns = ["base","user","profit_ave","new_profit","slmt_profit","sum_profit","new_fin",
         "slmt_fin","sum_fin",
         "new_shift","slmt_shift","all_shift","new_result","slmt_result","all_result","stock_shift","ojt_shift",
         "dmer1","dmer2","dmer3","aupay","paypay","rakuten_pay",
         "airpay","demaekan","austicker","total_visit", "visit","visit_per","interview","interview_per",
         "full_talk","full_talk_per","get","get_per",
         "out_interview_01","out_full_talk_01","out_full_talk_01_per","out_get_01","out_get_01_per",
         "out_interview_02","out_full_talk_02","out_full_talk_02_per","out_get_02","out_get_02_per",
         "out_interview_03","out_full_talk_03","out_full_talk_03_per","out_get_03","out_get_03_per",
         "out_interview_04","out_full_talk_04","out_full_talk_04_per","out_get_04","out_get_04_per",
         "out_interview_05","out_full_talk_05","out_full_talk_05_per","out_get_05","out_get_05_per",
         "out_interview_06","out_full_talk_06","out_full_talk_06_per","out_get_06","out_get_06_per",
         "out_interview_07","out_full_talk_07","out_full_talk_07_per","out_get_07","out_get_07_per",
         "out_interview_08","out_full_talk_08","out_full_talk_08_per","out_get_08","out_get_08_per",
         "out_interview_09","out_full_talk_09","out_full_talk_09_per","out_get_09","out_get_09_per",
         "out_interview_10","out_full_talk_10","out_full_talk_10_per","out_get_10","out_get_10_per",
         "out_interview_11","out_full_talk_11","out_full_talk_11_per","out_get_11","out_get_11_per",
         "out_interview_12","out_full_talk_12","out_full_talk_12_per","out_get_12","out_get_12_per",
         "out_interview_13","out_full_talk_13","out_full_talk_13_per","out_get_13","out_get_13_per",
         "cafe_visit","cafe_get","other_food_visit","other_food_get","car_visit","car_get",
         "other_retail_visit","other_retail_get","hair_salon_visit","hair_salon_get",
         "manipulative_visit","manipulative_get","other_service_visit","other_service_get",
         "dmer1_get","dmer2_get","dmer3_get","aupay1_get","aupay2_get","paypay_get","rakuten_pay_get","airpay_get"
    ]

    bom = "\uFEFF"
    csv = CSV.generate(bom) do |csv|
      csv << columns_ja
      @base_list.each do |base|
        base.each do |user|
          result_attributes = {}
          result_attributes["base"] = user["拠点"]
          result_attributes["user"] = user["名前"]
          result_attributes["profit_ave"] = (user["合計終着"] / user["予定シフト"]).round() rescue 0
          result_attributes["sum_profit"] = user["合計現状売上"]
          result_attributes["new_profit"] = user["新規現状売上"]
          result_attributes["slmt_profit"] = user["決済現状売上"]
          result_attributes["new_fin"] = user["新規終着"]
          result_attributes["slmt_fin"] = user["決済終着"]
          result_attributes["sum_fin"] = user["合計終着"]
          result_attributes["new_shift"] = user["予定新規シフト"]
          result_attributes["slmt_shift"] = user["予定決済シフト"]
          result_attributes["all_shift"] = user["予定シフト"]
          result_attributes["new_result"] = user["消化新規シフト"]
          result_attributes["slmt_result"] = user["消化決済シフト"]
          result_attributes["all_result"] = user["消化シフト"]
          result_attributes["stock_shift"] = user["予定シフト"] - user["消化シフト"]
          result_attributes["ojt_shift"] = user["消化帯同シフト"]
          result_attributes["dmer1"] = user["dメル第一成果件数"]
          result_attributes["dmer2"] = user["dメル第二成果件数"]
          result_attributes["dmer3"] = user["dメル第三成果件数"]
          result_attributes["aupay"] = user["auPay第一成果件数"]
          result_attributes["paypay"] = user["PayPay第一成果件数"]
          result_attributes["rakuten_pay"] = user["楽天ペイ第一成果件数"]
          result_attributes["airpay"] = user["AirPay第一成果件数"]
          result_attributes["demaekan"] = user["出前館第一成果件数"]
          result_attributes["austicker"] = user["auステッカー第一成果件数"]
          result_attributes["total_visit"] = user["訪問"].to_f.round(1)
          result_attributes["visit"] = user["応答"].to_f.round(1)
          result_attributes["visit_per"] = "#{(user["応答"].to_f / user["訪問"].to_f * 100).round() rescue 0}%"
          result_attributes["interview"] = user["対面"].to_f.round(1)
          result_attributes["interview_per"] = "#{(user["対面"].to_f / user["応答"].to_f * 100).round() rescue 0}%"
          result_attributes["full_talk"] = user["フル"].to_f.round(1)
          result_attributes["full_talk_per"] = "#{(user["フル"].to_f / user["対面"].to_f * 100).round() rescue 0}%"
          result_attributes["get"] = user["獲得"].to_f.round(1)
          result_attributes["get_per"] = "#{(user["獲得"].to_f / user["フル"].to_f * 100).round() rescue 0}%"
          result_attributes["out_interview_01"] = user["０１：どうゆうこと？：対面"]
          result_attributes["out_full_talk_01"] = user["０１：どうゆうこと？：フル"]
          result_attributes["out_full_talk_01_per"] = "#{(user["０１：どうゆうこと？：フル"] / user["０１：どうゆうこと？：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_01"] = user["０１：どうゆうこと？：成約"]
          result_attributes["out_get_01_per"] = "#{(user["０１：どうゆうこと？：成約"] / user["０１：どうゆうこと？：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_02"] = user["０２：君は誰？協会？：対面"]
          result_attributes["out_full_talk_02"] = user["０２：君は誰？協会？：フル"]
          result_attributes["out_full_talk_02_per"] = "#{(user["０２：君は誰？協会？：フル"] / user["０２：君は誰？協会？：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_02"] = user["０２：君は誰？協会？：成約"]
          result_attributes["out_get_02_per"] = "#{(user["０２：君は誰？協会？：成約"] / user["０２：君は誰？協会？：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_03"] = user["０３：もらうだけでいいの？：対面"]
          result_attributes["out_full_talk_03"] = user["０３：もらうだけでいいの？：フル"]
          result_attributes["out_full_talk_03_per"] = "#{(user["０３：もらうだけでいいの？：フル"] / user["０３：もらうだけでいいの？：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_03"] = user["０３：もらうだけでいいの？：成約"]
          result_attributes["out_get_03_per"] = "#{(user["０３：もらうだけでいいの？：成約"] / user["０３：もらうだけでいいの？：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_04"] = user["０４：PayPayのみ：対面"]
          result_attributes["out_full_talk_04"] = user["０４：PayPayのみ：フル"]
          result_attributes["out_full_talk_04_per"] = "#{(user["０４：PayPayのみ：フル"] / user["０４：PayPayのみ：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_04"] = user["０４：PayPayのみ：成約"]
          result_attributes["out_get_04_per"] = "#{(user["０４：PayPayのみ：成約"] / user["０４：PayPayのみ：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_05"] = user["０５：AirPayのみ：対面"]
          result_attributes["out_full_talk_05"] = user["０５：AirPayのみ：フル"]
          result_attributes["out_full_talk_05_per"] = "#{(user["０５：AirPayのみ：フル"] / user["０５：AirPayのみ：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_05"] = user["０５：AirPayのみ：成約"]
          result_attributes["out_get_05_per"] = "#{(user["０５：AirPayのみ：成約"] / user["０５：AirPayのみ：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_06"] = user["０６：カードのみ：対面"]
          result_attributes["out_full_talk_06"] = user["０６：カードのみ：フル"]
          result_attributes["out_full_talk_06_per"] = "#{(user["０６：カードのみ：フル"] / user["０６：カードのみ：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_06"] = user["０６：カードのみ：成約"]
          result_attributes["out_get_06_per"] = "#{(user["０６：カードのみ：成約"] / user["０６：カードのみ：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_07"] = user["０７：先延ばし：対面"]
          result_attributes["out_full_talk_07"] = user["０７：先延ばし：フル"]
          result_attributes["out_full_talk_07_per"] = "#{(user["０７：先延ばし：フル"] / user["０７：先延ばし：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_07"] = user["０７：先延ばし：成約"]
          result_attributes["out_get_07_per"] = "#{(user["０７：先延ばし：成約"] / user["０７：先延ばし：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_08"] = user["０８：現金のみ：対面"]
          result_attributes["out_full_talk_08"] = user["０８：現金のみ：フル"]
          result_attributes["out_full_talk_08_per"] = "#{(user["０８：現金のみ：フル"] / user["０８：現金のみ：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_08"] = user["０８：現金のみ：成約"]
          result_attributes["out_get_08_per"] = "#{(user["０８：現金のみ：成約"] / user["０８：現金のみ：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_09"] = user["０９：忙しい：対面"]
          result_attributes["out_full_talk_09"] = user["０９：忙しい：フル"]
          result_attributes["out_full_talk_09_per"] = "#{(user["０９：忙しい：フル"] / user["０９：忙しい：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_09"] = user["０９：忙しい：成約"]
          result_attributes["out_get_09_per"] = "#{(user["０９：忙しい：成約"] / user["０９：忙しい：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_10"] = user["１０：面倒くさい：対面"]
          result_attributes["out_full_talk_10"] = user["１０：面倒くさい：フル"]
          result_attributes["out_full_talk_10_per"] = "#{(user["１０：面倒くさい：フル"] / user["１０：面倒くさい：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_10"] = user["１０：面倒くさい：成約"]
          result_attributes["out_get_10_per"] = "#{(user["１０：面倒くさい：成約"] / user["１０：面倒くさい：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_11"] = user["１１：情報不足：対面"]
          result_attributes["out_full_talk_11"] = user["１１：情報不足：フル"]
          result_attributes["out_full_talk_11_per"] = "#{(user["１１：情報不足：フル"] / user["１１：情報不足：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_11"] = user["１１：情報不足：成約"]
          result_attributes["out_get_11_per"] = "#{(user["１１：情報不足：成約"] / user["１１：情報不足：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_12"] = user["１２：ペロ：対面"]
          result_attributes["out_full_talk_12"] = user["１２：ペロ：フル"]
          result_attributes["out_full_talk_12_per"] = "#{(user["１２：ペロ：フル"] / user["１２：ペロ：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_12"] = user["１２：ペロ：成約"]
          result_attributes["out_get_12_per"] = "#{(user["１２：ペロ：成約"] / user["１２：ペロ：フル"] * 100).round() rescue 0}%"
          result_attributes["out_interview_13"] = user["１３：その他：対面"]
          result_attributes["out_full_talk_13"] = user["１３：その他：フル"]
          result_attributes["out_full_talk_13_per"] = "#{(user["１３：その他：フル"] / user["１３：その他：対面"] * 100).round() rescue 0}%"
          result_attributes["out_get_13"] = user["１３：その他：成約"]
          result_attributes["out_get_13_per"] = "#{(user["１３：その他：成約"] / user["１３：その他：フル"] * 100).round() rescue 0}%"
          result_attributes["cafe_visit"] = user["喫茶・カフェ訪問数"]
          result_attributes["cafe_get"] = user["喫茶・カフェ獲得数"]
          result_attributes["other_food_visit"] = user["その他飲食訪問数"]
          result_attributes["other_food_get"] = user["その他飲食獲得数"]
          result_attributes["car_visit"] = user["車屋訪問数"]
          result_attributes["car_get"] = user["車屋獲得数"]
          result_attributes["other_retail_visit"] = user["その他小売訪問数"]
          result_attributes["other_retail_get"] = user["その他小売獲得数"]
          result_attributes["hair_salon_visit"] = user["理容・美容訪問数"]
          result_attributes["hair_salon_get"] = user["理容・美容獲得数"]
          result_attributes["manipulative_visit"] = user["整体・鍼灸訪問数"]
          result_attributes["manipulative_get"] = user["整体・鍼灸獲得数"]
          result_attributes["other_service_visit"] = user["その他サービス訪問数"]
          result_attributes["other_service_get"] = user["その他サービス獲得数"]
          result_attributes["dmer1_get"] = user["dメル獲得数"]
          result_attributes["dmer2_get"] = user["dメルアクセプタンス数"]
          result_attributes["dmer3_get"] = user["dメル2回目決済数"]
          result_attributes["aupay1_get"] = user["auPay獲得数"]
          result_attributes["aupay2_get"] = user["auPayアクセプタンス数"]
          result_attributes["paypay_get"] = user["PayPay獲得数"]
          result_attributes["rakuten_pay_get"] = user["楽天ペイ獲得数"]
          result_attributes["airpay_get"] = user["AirPay獲得数"]
          csv << result_attributes.values_at(*columns)
        end 
      end 
    end 
    create_csv(filename,csv)

  end 

  private 

  def base_profit_by_spread(sheets,user,index_cnt)
    sheets[index_cnt, 2] = user["名前"]
    sheets[index_cnt, 3] = (user["合計終着"] / user["予定シフト"]).round() rescue 0
    sheets[index_cnt, 4] = user["新規現状売上"]
    sheets[index_cnt, 5] = user["決済現状売上"]
    sheets[index_cnt, 6] = user["合計現状売上"]
    sheets[index_cnt, 7] = user["新規終着"]
    sheets[index_cnt, 8] = user["決済終着"]
    sheets[index_cnt, 9] = user["合計終着"]
    sheets[index_cnt, 10] = user["予定新規シフト"]
    sheets[index_cnt, 11] = user["予定決済シフト"]
    sheets[index_cnt, 12] = user["予定シフト"]
    sheets[index_cnt, 13] = user["消化新規シフト"]
    sheets[index_cnt, 14] = user["消化決済シフト"]
    sheets[index_cnt, 15] = user["消化シフト"]
    sheets[index_cnt, 16] = user["予定シフト"] - user["消化シフト"]
    sheets[index_cnt, 17] = user["消化帯同シフト"]
    sheets[index_cnt, 18] = user["dメル獲得数"]
    sheets[index_cnt, 19] = user["dメル第二成果件数"]
    sheets[index_cnt, 20] = user["dメル第三成果件数"]
    sheets[index_cnt, 21] = user["auPay獲得数"]
    sheets[index_cnt, 22] = user["auPay第一成果件数"]
    sheets[index_cnt, 23] = user["PayPay獲得数"]
    sheets[index_cnt, 24] = user["楽天ペイ第一成果件数"]
    sheets[index_cnt, 25] = user["AirPay第一成果件数"]
    sheets[index_cnt, 26] = user["出前館第一成果件数"]
    sheets[index_cnt, 27] = user["auステッカー第一成果件数"]
  end 

  def base_out_by_spread(sheets,user,index_cnt)
    sheets[index_cnt, 2] = user["名前"]
    sheets[index_cnt, 3] = user["訪問"]
    sheets[index_cnt, 4] = user["応答"]
    sheets[index_cnt, 6] = user["対面"]
    sheets[index_cnt, 8] = user["フル"]
    sheets[index_cnt, 10] = user["獲得"]
    sheets[index_cnt, 12] = user["０１：どうゆうこと？：対面"]
    sheets[index_cnt, 13] = user["０１：どうゆうこと？：フル"]
    sheets[index_cnt, 15] = user["０１：どうゆうこと？：成約"]
    sheets[index_cnt, 17] = user["０２：君は誰？協会？：対面"]
    sheets[index_cnt, 18] = user["０２：君は誰？協会？：フル"]
    sheets[index_cnt, 20] = user["０２：君は誰？協会？：成約"]
    sheets[index_cnt, 22] = user["０３：もらうだけでいいの？：対面"]
    sheets[index_cnt, 23] = user["０３：もらうだけでいいの？：フル"]
    sheets[index_cnt, 25] = user["０３：もらうだけでいいの？：成約"]
    sheets[index_cnt, 27] = user["０４：PayPayのみ：対面"]
    sheets[index_cnt, 28] = user["０４：PayPayのみ：フル"]
    sheets[index_cnt, 30] = user["０４：PayPayのみ：成約"]
    sheets[index_cnt, 32] = user["０５：AirPayのみ：対面"]
    sheets[index_cnt, 33] = user["０５：AirPayのみ：フル"]
    sheets[index_cnt, 35] = user["０５：AirPayのみ：成約"]
    sheets[index_cnt, 37] = user["０６：カードのみ：対面"]
    sheets[index_cnt, 38] = user["０６：カードのみ：フル"]
    sheets[index_cnt, 40] = user["０６：カードのみ：成約"]
    sheets[index_cnt, 42] = user["０７：先延ばし：対面"]
    sheets[index_cnt, 43] = user["０７：先延ばし：フル"]
    sheets[index_cnt, 45] = user["０７：先延ばし：成約"]
    sheets[index_cnt, 47] = user["０８：現金のみ：対面"]
    sheets[index_cnt, 48] = user["０８：現金のみ：フル"]
    sheets[index_cnt, 50] = user["０８：現金のみ：成約"]
    sheets[index_cnt, 52] = user["０９：忙しい：対面"]
    sheets[index_cnt, 53] = user["０９：忙しい：フル"]
    sheets[index_cnt, 55] = user["０９：忙しい：成約"]
    sheets[index_cnt, 57] = user["１０：面倒くさい：対面"]
    sheets[index_cnt, 58] = user["１０：面倒くさい：フル"]
    sheets[index_cnt, 60] = user["１０：面倒くさい：成約"]
    sheets[index_cnt, 62] = user["１１：情報不足：対面"]
    sheets[index_cnt, 63] = user["１１：情報不足：フル"]
    sheets[index_cnt, 65] = user["１１：情報不足：成約"]
    sheets[index_cnt, 67] = user["１２：ペロ：対面"]
    sheets[index_cnt, 68] = user["１２：ペロ：フル"]
    sheets[index_cnt, 70] = user["１２：ペロ：成約"]
    sheets[index_cnt, 72] = user["１３：その他：対面"]
    sheets[index_cnt, 73] = user["１３：その他：フル"]
    sheets[index_cnt, 75] = user["１３：その他：成約"]
    sheets[index_cnt, 77] = user["喫茶・カフェ訪問数"]
    sheets[index_cnt, 78] = user["喫茶・カフェ獲得数"]
    sheets[index_cnt, 79] = user["その他飲食訪問数"]
    sheets[index_cnt, 80] = user["その他飲食獲得数"]
    sheets[index_cnt, 81] = user["車屋訪問数"]
    sheets[index_cnt, 82] = user["車屋獲得数"]
    sheets[index_cnt, 83] = user["その他小売訪問数"]
    sheets[index_cnt, 84] = user["その他小売獲得数"]
    sheets[index_cnt, 85] = user["理容・美容訪問数"]
    sheets[index_cnt, 86] = user["理容・美容獲得数"]
    sheets[index_cnt, 87] = user["整体・鍼灸訪問数"]
    sheets[index_cnt, 88] = user["整体・鍼灸獲得数"]
    sheets[index_cnt, 89] = user["その他サービス訪問数"]
    sheets[index_cnt, 90] = user["その他サービス獲得数"]
  end

  def create_csv(filename, csv1)
    #ファイル書き込み
    File.open("./#{filename}.csv", "w") do |file|
      file.write(csv1)
    end
    #send_fileを使ってCSVファイル作成後に自動でダウンロードされるようにする
    stat = File::stat("./#{filename}.csv")
    send_file("./#{filename}.csv", filename: "#{filename}.csv", length: stat.size)
  end

  def back_retirement
    redirect_to error_pages_path if current_user.position != "権限①"
  end



end
