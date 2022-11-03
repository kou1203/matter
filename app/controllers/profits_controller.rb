class ProfitsController < ApplicationController
  before_action :authenticate_user!
  before_action :back_retirement, only: [:index]
  def index
    profit_pack # 必要な変数がまとまった関数
  end 

  def sum_export 
    profit_pack # 必要な変数がまとまった関数
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
    profit_pack # 必要な変数がまとまった関数
    head :no_content
    filename = "#{@end_date.month}月個別実売資料"
    columns_ja = [
      "拠点","ユーザー", "キャッシュ1日Ave","新規売上","決済売上","現状売上",
      "新規終着","決済終着","終着売上","新規予定","決済予定","予定シフト",
      "新規消化","決済消化","消化シフト","残シフト","帯同シフト",
      "dメル","dメル決済","dメル2回目決済","auPay決済","PayPay",
      "楽天ペイ","AirPay","出前館", "auステッカー",
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
         "out_interview_03","out_full_talk_03","out_full_talk_03_per","out_get_02","out_get_03_per",
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
         "dmer1","dmer2","dmer3","aupay1","aupay2","paypay","rakuten_pay","airpay"
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
          result_attributes["dmer1"] = user["dメル獲得数"]
          result_attributes["dmer2"] = user["dメルアクセプタンス数"]
          result_attributes["dmer3"] = user["dメル2回目決済数"]
          result_attributes["aupay1"] = user["auPay獲得数"]
          result_attributes["aupay2"] = user["auPayアクセプタンス数"]
          result_attributes["paypay"] = user["PayPay獲得数"]
          result_attributes["rakuten_pay"] = user["楽天ペイ獲得数"]
          result_attributes["airpay"] = user["AirPay獲得数"]
          csv << result_attributes.values_at(*columns)
        end 
      end 
    end 
    create_csv(filename,csv)

  end 

  private 

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

  def profit_pack
    # 期間
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @start_date = @month.prev_month.beginning_of_month.since(25.days).to_date # 26日
    @end_date = @month.beginning_of_month.since(24.days).to_date # 25日
    @closing_date = @month.next_month.beginning_of_month.since(4.days).to_date
    @start_done = @month.beginning_of_month.to_date # 月初
    @end_done = @month.end_of_month.to_date # 月末
    @rakuten_start = @month.prev_month.beginning_of_month.since(15.days).to_date # 16日
    @rakuten_end = @month.beginning_of_month.since(14.days).to_date # 15日
    @rakuten_change_date = @month.beginning_of_month.since(17.days).to_date # 18日
    @results = 
      Result.includes(:user,:result_cash).where(shift: "キャッシュレス新規").where(date: @start_date..@end_date)
      .or(Result.includes(:user,:result_cash).where(shift: "キャッシュレス決済").where(date: @start_date..@end_date))
      .or(Result.includes(:user,:result_cash).where(shift: "帯同").where(date: @start_date..@end_date))
    @shifts = 
      Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
      .or(Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス決済"))
      .or(Shift.where(start_time: @start_date..@end_date).where(shift: "帯同"))
    # 楽天ペイ全体
    rakuten_all_len = RakutenPay.where(status: "OK").where(result_point: @rakuten_start..@rakuten_end).length
    rakuten_all_len_prev = RakutenPay.where(status: "OK").where(result_point: @rakuten_start.prev_month..@rakuten_end.prev_month).length
    # 全体AirPay
    airpay_all = 
    Airpay.where(date: @start_date..@end_date).where(status: "審査完了")
    .or(
      Airpay.where(date: @start_date..@end_date).where(status: "審査中")
    )
    airpay_all_len = airpay_all.length
    airpay_all_len_ave = (airpay_all_len.to_f / @results.where(shift: "キャッシュレス新規").length).round(1)
    airpay_all_len_fin = (airpay_all_len_ave * @shifts.where(shift: "キャッシュレス新規").length * 0.85).round() rescue 0
  # AirPay単価
  airpay_price = 
    if airpay_all_len_fin >= 300
      15000
    elsif airpay_all_len_fin >= 75
      11000
    else  
      3000
    end 
    # 単価
      # 単価
      dmer_price_1 = 9000
      dmer_price_2 = 5000
      dmer_price_3 = 5000
      aupay_price = 13500
      paypay_price = 2000
    # 大元の成約率
    dmer_result1_per = 0.64
    dmer_result2_per = 0.58
    dmer_result3_per = 0.52
    dmer_result_per_prev = 0.9
    dmer_result3_per_prev = 1
    dmer_prev_month_slmt_per = 0.9
    aupay_slmt_per = 0.75
    aupay_slmt_per_prev = 0.71
    airpay_result_per = 0.75
    airpay_result_per_prev = 0.87
    @closing_span = (@closing_date.to_date - @end_date.to_date).to_i
    @period_span = (Date.today.to_date - @end_date.to_date).to_i
    # 増加率
    if Date.today.to_date >= @end_date.to_date
    # dメル
    @dmer1_inc_per = (1.0 - dmer_result1_per) / @closing_span * @period_span
    @dmer2_inc_per = (1.0 - dmer_result2_per) / @closing_span * @period_span
    @dmer3_inc_per = (1.0 - dmer_result3_per) / @closing_span * @period_span
    @dmer_prev_inc_per = (1.0 - dmer_result_per_prev) / @closing_span * @period_span
    # auPay
    @aupay_inc_per = (1.0 - aupay_slmt_per) / @closing_span * @period_span
    @aupay_prev_inc_per = (1.0 - aupay_slmt_per_prev) / @closing_span * @period_span
    # AirPay
    @airpay_inc_per = (1.0 - airpay_result_per) / @closing_span * @period_span
    @airpay_prev_inc_per = (1.0 - airpay_result_per_prev) / @closing_span * @period_span
    # 減少率
    # dメル
    @dmer1_dec_per = dmer_result1_per / @closing_span * @period_span
    @dmer2_dec_per = dmer_result2_per / @closing_span * @period_span
    @dmer3_dec_per = dmer_result3_per / @closing_span * @period_span
    @dmer_prev_dec_per = dmer_result_per_prev / @closing_span * @period_span
    # auPay
    @aupay_dec_per = aupay_slmt_per / @closing_span * @period_span
    @aupay_prev_dec_per = aupay_slmt_per_prev / @closing_span * @period_span
    # AirPay
    @airpay_dec_per = airpay_result_per / @closing_span * @period_span
    @airpay_prev_dec_per = airpay_result_per_prev / @closing_span * @period_span
  else  
    # dメル
    @dmer1_inc_per = 0
    @dmer2_inc_per = 0
    @dmer3_inc_per = 0
    @dmer_prev_inc_per = 0
    # auPay
    @aupay_inc_per = 0
    @aupay_prev_inc_per = 0
    # AirPay
    @airpay_inc_per = 0
    @airpay_prev_inc_per = 0
    # 減少率
    # dメル
    @dmer1_dec_per = 0
    @dmer2_dec_per = 0
    @dmer3_dec_per = 0
    @dmer_prev_dec_per = 0
    # auPay
    @aupay_dec_per = 0
    @aupay_prev_dec_per = 0
    # AirPay
    @airpay_dec_per = 0
    @airpay_prev_dec_per = 0
    end 

    # 成果率




    # ハッシュ・リストデータ
    @chubu_cash_list = []
    @kansai_cash_list = []
    @kanto_cash_list = []
    @partner_cash_list = []
    @femto_list = []
    @summit_list = []
    @retire_list = []
    @all_list = []
    @bases = ["中部SS", "関西SS", "関東SS", "2次店","退職"]
    @users = 
      User.where(base_sub: "キャッシュレス")
      .or(
        User.where(base_sub: "フェムト")
      )
      .or(
        User.where(base_sub: "サミット")
      )
    # ハッシュの中身
      @bases.each do |base| # 拠点ごとに繰り返す
        @users.where(base: base).each do |user| #ユーザーごとに繰り返す
          person_hash = {}
        # ユーザー情報
          user_result = @results.where(user_id: user.id)
          if user.position == "退職"
            person_hash["拠点"] = "その他"
          elsif user.base_sub == "フェムト"
            person_hash["拠点"] = "フェムト"
          elsif user.base_sub == "サミット"
            person_hash["拠点"] = "サミット"
          else  
            person_hash["拠点"] = user.base 
          end
          person_hash["名前"] = user.name
          person_hash["役職"] = user.position_sub
        # 予定シフト
          user_shift = @shifts.where(user_id: user.id)
          person_hash["予定シフト"] = user_shift.length
          person_hash["予定新規シフト"] = user_shift.where(shift: "キャッシュレス新規").length
          person_hash["予定決済シフト"] = user_shift.where(shift: "キャッシュレス決済").length
          person_hash["予定決済シフト"] = user_shift.where(shift: "キャッシュレス決済").length
          person_hash["予定帯同シフト"] = user_shift.where(shift: "帯同").length
          user_shift26_10 = user_shift.where(shift: "キャッシュレス新規").where(start_time: @start_date..@end_date.beginning_of_month.since(9.days)).length
        # 消化シフト
          user_result_shift = 
            user_result.where(shift: "キャッシュレス新規")
              .or(
                user_result.where(shift: "キャッシュレス決済")
              )
          person_hash["消化シフト"] = user_result_shift.length 
          person_hash["消化新規シフト"] = user_result_shift.where(shift: "キャッシュレス新規").length 
          person_hash["消化決済シフト"] = user_result_shift.where(shift: "キャッシュレス決済").length 
          person_hash["消化帯同シフト"] = user_result_shift.where(shift: "帯同").length 
          user_result26_10 = user_result_shift.where(shift: "キャッシュレス新規").where(date: @start_date..@end_date.beginning_of_month.since(9.days)).length
        # 基準値
          person_hash["訪問"] = user_result.sum("first_total_visit + latter_total_visit") / person_hash["消化新規シフト"] rescue 0
          person_hash["応答"] = user_result.sum("first_visit + latter_visit") / person_hash["消化新規シフト"] rescue 0
          person_hash["対面"] = user_result.sum("first_interview + latter_interview") / person_hash["消化新規シフト"] rescue 0
          person_hash["フル"] = user_result.sum("first_full_talk + latter_full_talk") / person_hash["消化新規シフト"] rescue 0
          person_hash["獲得"] = user_result.sum("first_get + latter_get") / person_hash["消化新規シフト"] rescue 0
        # 切り返し
        person_hash["０１：どうゆうこと？：対面"] = user_result.sum("out_interview_01") / person_hash["消化新規シフト"] rescue 0
        person_hash["０１：どうゆうこと？：フル"] = user_result.sum("out_full_talk_01") / person_hash["消化新規シフト"] rescue 0
        person_hash["０１：どうゆうこと？：成約"] = user_result.sum("out_get_01") / person_hash["消化新規シフト"] rescue 0
        person_hash["０２：君は誰？協会？：対面"] = user_result.sum("out_interview_02") / person_hash["消化新規シフト"] rescue 0
        person_hash["０２：君は誰？協会？：フル"] = user_result.sum("out_full_talk_02") / person_hash["消化新規シフト"] rescue 0
        person_hash["０２：君は誰？協会？：成約"] = user_result.sum("out_get_02") / person_hash["消化新規シフト"] rescue 0
        person_hash["０３：もらうだけでいいの？：対面"] = user_result.sum("out_interview_03") / person_hash["消化新規シフト"] rescue 0
        person_hash["０３：もらうだけでいいの？：フル"] = user_result.sum("out_full_talk_03") / person_hash["消化新規シフト"] rescue 0
        person_hash["０３：もらうだけでいいの？：成約"] = user_result.sum("out_get_03") / person_hash["消化新規シフト"] rescue 0
        person_hash["０４：PayPayのみ：対面"] = user_result.sum("out_interview_04") / person_hash["消化新規シフト"] rescue 0
        person_hash["０４：PayPayのみ：フル"] = user_result.sum("out_full_talk_04") / person_hash["消化新規シフト"] rescue 0
        person_hash["０４：PayPayのみ：成約"] = user_result.sum("out_get_04") / person_hash["消化新規シフト"] rescue 0
        person_hash["０５：AirPayのみ：対面"] = user_result.sum("out_interview_05") / person_hash["消化新規シフト"] rescue 0
        person_hash["０５：AirPayのみ：フル"] = user_result.sum("out_full_talk_05") / person_hash["消化新規シフト"] rescue 0
        person_hash["０５：AirPayのみ：成約"] = user_result.sum("out_get_05") / person_hash["消化新規シフト"] rescue 0
        person_hash["０６：カードのみ：対面"] = user_result.sum("out_interview_06") / person_hash["消化新規シフト"] rescue 0
        person_hash["０６：カードのみ：フル"] = user_result.sum("out_full_talk_06") / person_hash["消化新規シフト"] rescue 0
        person_hash["０６：カードのみ：成約"] = user_result.sum("out_get_06") / person_hash["消化新規シフト"] rescue 0
        person_hash["０７：先延ばし：対面"] = user_result.sum("out_interview_07") / person_hash["消化新規シフト"] rescue 0
        person_hash["０７：先延ばし：フル"] = user_result.sum("out_full_talk_07") / person_hash["消化新規シフト"] rescue 0
        person_hash["０７：先延ばし：成約"] = user_result.sum("out_get_07") / person_hash["消化新規シフト"] rescue 0
        person_hash["０８：現金のみ：対面"] = user_result.sum("out_interview_08") / person_hash["消化新規シフト"] rescue 0
        person_hash["０８：現金のみ：フル"] = user_result.sum("out_full_talk_08") / person_hash["消化新規シフト"] rescue 0
        person_hash["０８：現金のみ：成約"] = user_result.sum("out_get_08") / person_hash["消化新規シフト"] rescue 0
        person_hash["０９：忙しい：対面"] = user_result.sum("out_interview_09") / person_hash["消化新規シフト"] rescue 0
        person_hash["０９：忙しい：フル"] = user_result.sum("out_full_talk_09") / person_hash["消化新規シフト"] rescue 0
        person_hash["０９：忙しい：成約"] = user_result.sum("out_get_09") / person_hash["消化新規シフト"] rescue 0
        person_hash["１０：面倒くさい：対面"] = user_result.sum("out_interview_10") / person_hash["消化新規シフト"] rescue 0
        person_hash["１０：面倒くさい：フル"] = user_result.sum("out_full_talk_10") / person_hash["消化新規シフト"] rescue 0
        person_hash["１０：面倒くさい：成約"] = user_result.sum("out_get_10") / person_hash["消化新規シフト"] rescue 0
        person_hash["１１：情報不足：対面"] = user_result.sum("out_interview_11") / person_hash["消化新規シフト"] rescue 0
        person_hash["１１：情報不足：フル"] = user_result.sum("out_full_talk_11") / person_hash["消化新規シフト"] rescue 0
        person_hash["１１：情報不足：成約"] = user_result.sum("out_get_11") / person_hash["消化新規シフト"] rescue 0
        person_hash["１２：ペロ：対面"] = user_result.sum("out_interview_12") / person_hash["消化新規シフト"] rescue 0
        person_hash["１２：ペロ：フル"] = user_result.sum("out_full_talk_12") / person_hash["消化新規シフト"] rescue 0
        person_hash["１２：ペロ：成約"] = user_result.sum("out_get_12") / person_hash["消化新規シフト"] rescue 0
        person_hash["１３：その他：対面"] = user_result.sum("out_interview_13") / person_hash["消化新規シフト"] rescue 0
        person_hash["１３：その他：フル"] = user_result.sum("out_full_talk_13") / person_hash["消化新規シフト"] rescue 0
        person_hash["１３：その他：成約"] = user_result.sum("out_get_13") / person_hash["消化新規シフト"] rescue 0
        person_hash["喫茶・カフェ訪問数"] = user_result.sum("cafe_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["喫茶・カフェ獲得数"] = user_result.sum("cafe_get") / person_hash["消化新規シフト"] rescue 0
        person_hash["その他飲食訪問数"] = user_result.sum("other_food_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["その他飲食獲得数"] = user_result.sum("other_food_get") / person_hash["消化新規シフト"] rescue 0
        person_hash["車屋訪問数"] = user_result.sum("car_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["車屋獲得数"] = user_result.sum("car_get") / person_hash["消化新規シフト"] rescue 0
        person_hash["その他小売訪問数"] = user_result.sum("other_retail_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["その他小売獲得数"] = user_result.sum("other_retail_get") / person_hash["消化新規シフト"] rescue 0
        person_hash["理容・美容訪問数"] = user_result.sum("hair_salon_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["理容・美容獲得数"] = user_result.sum("hair_salon_get") / person_hash["消化新規シフト"] rescue 0
        person_hash["整体・鍼灸訪問数"] = user_result.sum("manipulative_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["整体・鍼灸獲得数"] = user_result.sum("manipulative_get") / person_hash["消化新規シフト"] rescue 0
        person_hash["その他サービス訪問数"] = user_result.sum("other_service_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["その他サービス獲得数"] = user_result.sum("other_service_get") / person_hash["消化新規シフト"] rescue 0
        # dメル
          dmer_user = 
            Dmer.where(user_id: user.id).includes(:store_prop)
          dmer_slmter = 
            Dmer.where(settlementer_id: user.id)
          # 現状売上
            # 第一成果
            dmer_result1 = 
              dmer_user.where(result_point: @start_done..@end_done)
              .where("? >= settlement", @end_done)
              .where(status: "審査OK")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "×")
              .where.not(industry_status: "要確認")
              .or(
                dmer_user.where(settlement: @start_done..@end_done)
                .where("? >= result_point", @end_done)
                .where(status: "審査OK")
                .where.not(industry_status: "NG")
                .where.not(industry_status: "×")
                .where.not(industry_status: "要確認")
              )
            dmer_result1_profit = dmer_result1.sum(:profit_new)
            person_hash["dメル第一成果件数"] = dmer_result1.length
            person_hash["dメル現状売上1"] = dmer_result1_profit
            # 第二成果
            dmer_result2 = 
              dmer_slmter.where(status_update_settlement: @start_done..@end_done)
              .where(status: "審査OK")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "×")
              .where.not(industry_status: "要確認")
              .where(status_settlement: "完了")

              dmer_result2_profit = dmer_result2.sum(:profit_settlement)
            person_hash["dメル第二成果件数"] = dmer_result2.length
            person_hash["dメル現状売上2"] = dmer_result2_profit
            # 第三成果
            dmer_result3 = 
              dmer_slmter.where(settlement_second: @start_done..@end_done)
              .where("? >= status_update_settlement", @end_done)
              .where(status: "審査OK")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "×")
              .where.not(industry_status: "要確認")
              .where(status_settlement: "完了")
              .or(
                dmer_slmter
                .where(status_update_settlement: @start_done..@end_done)
                .where("? >= settlement_second", @end_done)
                .where(status: "審査OK")
                .where.not(industry_status: "NG")
                .where.not(industry_status: "×")
                .where.not(industry_status: "要確認")
                .where(status_settlement: "完了")
              )
            dmer_result3_profit = dmer_result3.sum(:profit_second_settlement)
            person_hash["dメル第三成果件数"] = dmer_result3.length
            person_hash["dメル現状売上3"] = dmer_result3_profit
          
          # 獲得数
            dmer_uq = dmer_user.where(date: @start_date..@end_date).where(store_prop: {head_store: nil})
            person_hash["dメルアクセプタンス数"] = dmer_slmter.where(picture: @start_date..@end_date).length 
            person_hash["dメル2回目決済数"] = dmer_slmter.where(settlement_second: @start_date..@end_date).length

            dmer_def =  dmer_uq.where(status: "自社不備")
            .or(dmer_uq.where(status: "審査NG"))
            .or(dmer_uq.where(status: "申込取消"))
            .or(dmer_uq.where(status: "申込取消（不備）"))
            .or(dmer_uq.where(status: "社内確認中"))
            .or(dmer_uq.where(status: "審査OK").where(industry_status: "NG"))
            .or(dmer_uq.where(status: "審査OK").where(industry_status: "×"))
            .or(dmer_uq.where(status: "不備対応中"))
            dmer_db = 
            dmer_user.where(share: @start_date..@end_date).where.not(store_prop: {head_store: nil})
            .where.not(industry_status: "×").where.not(industry_status: "NG").where.not(industry_status: "要確認")
            .where.not(status: "不備対応中")
            .where.not(status: "審査NG")
            .where.not(status: "本店審査待ち")
            dmer_len = dmer_uq.length  - dmer_def.length + dmer_db.length #評価件数
            dmer_slmt2nd = dmer_slmter.where(settlement_second: @start_done..@end_done)
            person_hash["dメル獲得数"] = dmer_uq.length
            if dmer_len == 0
              dmer_len_ave = 0
            else
              dmer_len_ave = (dmer_len.to_f / person_hash["消化新規シフト"]).round(1) rescue 0
            end 
          # 評価件数
            dmer_val1_period =  
            dmer_user.where(status: "審査OK")
            .where.not(industry_status: "×")
            .where.not(industry_status: "NG")
            .where.not(industry_status: "要確認")
            .where(date: @start_date..@end_date)
            dmer_val1_period = 
              dmer_val1_period.where(result_point: @start_date..@end_done)
              .where("? >= settlement",@end_done)
              .or(
                dmer_val1_period.where(settlement: @start_date..@end_done)
                .where("? >= result_point",@end_done)
              )
              
            dmer_val2_period = 
            dmer_user.where(status: "審査OK")
            .where.not(industry_status: "×")
            .where.not(industry_status: "NG")
            .where.not(industry_status: "要確認")
            .where(date: @start_date..@end_date)
            .where("? >= status_update_settlement",@end_done)
            .where(status_settlement: "完了")
            dmer_val3_period = dmer_val2_period.where.not(settlement_second: nil)
            dmer_val1_period_len = dmer_val1_period.length
            dmer_val2_period_len = dmer_val2_period.length
            dmer_val3_period_len = dmer_val3_period.length
          # 過去月の決済対象
            dmer_slmt_tgt_prev = 
              dmer_user.where("settlement_deadline >= ?", @start_date)
              .where("? > date", @start_date)
              .where(status: "審査OK")
              .where.not(industry_status: "×")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "要確認")
              .where(status_update_settlement: nil)
              .or(
                dmer_user.where("settlement_deadline >= ?", @start_date)
                .where("? > date", @start_date)
                .where(status: "審査OK")
                .where(status_settlement: "完了")
                .where.not(industry_status: "×")
                .where.not(industry_status: "NG")
                .where.not(industry_status: "要確認")
                .where(status_update_settlement: @start_done..@end_done)
              )
              dmer_slmt_tgt_prev_len = dmer_slmt_tgt_prev.length rescue 0
              # 決済期限切れ
              dmer_slmt_dead = 
                dmer_slmt_tgt_prev.where(status_settlement: "期限切れ")
                .where(status_update_settlement: nil)
              dmer_slmt_dead_len = dmer_slmt_dead.length
              # 過去の案件で対象月に成果になったもの
              dmer_slmt_prev_val =  
                dmer_slmt_tgt_prev.where(status_update_settlement: @start_done..@end_done)
              dmer_2ndslmt_prev_val = 
                dmer_slmt_prev_val.where("? >= settlement_second", @month.next_month.end_of_month)
              dmer_slmt_prev_val_len = dmer_slmt_prev_val.length
              dmer_2ndslmt_prev_val_len = dmer_2ndslmt_prev_val.length
          # 終着
            # 第一成果
              # 期間内
              dmer_result1_fin_this_month_len = 
              (
                (dmer_len - dmer_val1_period_len).to_f / person_hash["消化新規シフト"] * person_hash["予定新規シフト"] * (dmer_result1_per - @dmer1_dec_per)
              ).round() rescue 0 
                dmer_result1_fin_this_month = 
                (dmer_price_1 * dmer_result1_fin_this_month_len) + ((dmer_result1.where(date: @start_date..@end_date).length.to_f * (dmer_result1_per + @dmer1_inc_per)).round() * dmer_price_1)

              # 過去月
              dmer_result1_fin_prev_month_len =
              (
                (dmer_slmt_tgt_prev.length - dmer_slmt_prev_val_len).to_f * (dmer_prev_month_slmt_per - @dmer_prev_dec_per)
              ).round()
                dmer_result1_fin_prev_month = 
                  (dmer_price_1 * dmer_result1_fin_prev_month_len) + 
                  ((dmer_result1.where("? > date",@start_date).length.to_f * (dmer_prev_month_slmt_per + @dmer_prev_inc_per)).round() * dmer_price_1)
              # 合計
              dmer_result1_fin = dmer_result1_fin_this_month + dmer_result1_fin_prev_month
              # person_hash["dメル一次成果終着（期間内）"] = dmer_result1_fin_prev_month
              # person_hash["dメル一次成果終着（過去月）"] = dmer_result1_fin_this_month
              if (person_hash["dメル現状売上1"] > dmer_result1_fin) || (Date.today >= @closing_date)
                person_hash["dメル一次成果終着"] = person_hash["dメル現状売上1"]
              else
              person_hash["dメル一次成果終着"] = dmer_result1_fin
              end 
            # 第二成果
              # 期間内
              dmer_result2_fin_this_month_len =
              (
                (dmer_len - dmer_val2_period_len).to_f / person_hash["消化新規シフト"] * person_hash["予定新規シフト"] * (dmer_result2_per - @dmer2_dec_per)
              ).round() rescue 0
              dmer_result2_fin_this_month = 
              (dmer_price_2 * dmer_result2_fin_this_month_len) + 
              ((dmer_result2.where(date: @start_date..@end_date).length.to_f * (dmer_result2_per + @dmer2_inc_per)).round() * dmer_price_2)
              
              dmer_result2_fin_prev_month = 
              (dmer_price_2 * dmer_result1_fin_prev_month_len) + 
              ( (dmer_result2.where("? > date",@start_date).length.to_f * @dmer_prev_inc_per).round() * dmer_price_2 )
              # 合計
              dmer_result2_fin = dmer_result2_fin_this_month + dmer_result2_fin_prev_month
              # person_hash["dメル二次成果終着（期間内）"] = dmer_result2_fin_this_month
              # person_hash["dメル二次成果終着（過去）"] = dmer_result2_fin_prev_month
              if (person_hash["dメル現状売上2"] > dmer_result2_fin) || (Date.today >= @closing_date)
                person_hash["dメル二次成果終着"] = person_hash["dメル現状売上2"]
              else
                person_hash["dメル二次成果終着"] = dmer_result2_fin
              end
            # 第三成果
              dmer_result3 = 
                dmer_slmter.where(settlement_second: @start_done..@end_done)
                .where.not(industry_status: "NG")
                .where.not(industry_status: "×")
                .where.not(industry_status: "要確認")
                .where(status: "審査OK")
                .where(status_settlement: "完了")
                .where("? >= status_update_settlement", @end_done)
                .or(
                  dmer_slmter.where(status_update_settlement: @start_done..@end_done)
                  .where.not(industry_status: "NG")
                  .where.not(industry_status: "×")
                  .where.not(industry_status: "要確認")
                  .where(status: "審査OK")
                  .where(status_settlement: "完了")
                  .where("? >= settlement_second", @end_done)
                )
              dmer_slmt2nd_profits = dmer_result3.sum(:profit_second_settlement)
              dmer_result3_len = dmer_result3.length
              dmer_slmt2nd_len = dmer_slmt2nd.length
              # 期間内
              dmer_result3_fin_this_month_len = 
                    (
                      (dmer_len - dmer_val3_period_len).to_f / 
                      person_hash["消化新規シフト"] * person_hash["予定新規シフト"] * (dmer_result3_per - @dmer3_dec_per)
                    ).round() rescue 0 
                dmer_result3_fin_this_month = 
                  (dmer_price_3 * dmer_result3_fin_this_month_len) + 
                  ((dmer_result3.where(date: @start_date..@end_date).length.to_f * (dmer_result3_per + @dmer3_inc_per)).round() * dmer_price_3)
              dmer_result3_fin_prev_month = 
                (
                  dmer_price_3 * (dmer_slmt_tgt_prev_len - dmer_2ndslmt_prev_val_len - dmer_slmt_dead_len)
                ) + (dmer_result3.where("? > date",@start_date).sum(:profit_second_settlement))
              dmer_result3_fin = dmer_result3_fin_this_month + dmer_result3_fin_prev_month
              # person_hash["dメル三次成果終着（期間内）"] = dmer_result3_fin_this_month
              # person_hash["dメル三次成果終着（過去月）"] = dmer_result3_fin_prev_month
              if (person_hash["dメル現状売上3"] > dmer_result3_fin) || (Date.today >= @closing_date)
                person_hash["dメル三次成果終着"] = person_hash["dメル現状売上3"]
              else  
                person_hash["dメル三次成果終着"] = dmer_result3_fin
              end 
        # auPay
          aupay_user = Aupay.includes(:store_prop).where(user_id: user.id)
          aupay_uq = aupay_user.where(date: @start_date..@end_date) 
          aupay_slmter = 
            Aupay.where(settlementer_id: user.id)
          # 過去の決済対象
            aupay_slmt_tgt_prev = 
              aupay_user.where("settlement_deadline >= ?", @start_date)
              .where("? > date", @start_date)
              .where(status: "審査通過")
              .where(status_update_settlement: nil)
              .or(
                aupay_user.where("settlement_deadline >= ?", @start_date)
                .where("? > date", @start_date)
                .where(status: "審査通過")
                .where(status_update_settlement: @start_done..@end_done)
              )
            aupay_slmt_tgt_prev_len = aupay_slmt_tgt_prev.length
            aupay_slmt_prev_val = 
            aupay_slmt_tgt_prev.where(status_update_settlement: @start_done..@end_done)
            aupay_slmt_prev_val_len = aupay_slmt_prev_val.length
          # 現状売上
            # 一次成果
              aupay_result1 = 
                aupay_slmter.where(status_update_settlement: @start_done..@end_done)
                .where(status: "審査通過")
                .where(status_settlement: "完了")
              aupay_result1_profit = aupay_result1.sum(:profit_settlement)
              person_hash["auPay獲得数"] = aupay_uq.length
              person_hash["auPayアクセプタンス数"] = aupay_slmter.where(picture: @start_date..@end_date).length
              person_hash["auPay第一成果件数"] = aupay_result1.length
              person_hash["auPay現状売上1"] = aupay_result1_profit
          # 終着
            # 一次成果
              # 期間内
              # 過去月
              aupay_result1_fin_prev_month_len = 
                (
                  (aupay_slmt_tgt_prev_len - aupay_slmt_prev_val_len) * (aupay_slmt_per_prev - @aupay_prev_dec_per)
                ).round() rescue 0
                aupay_result1_fin_prev_month = 
                  (aupay_price * aupay_result1_fin_prev_month_len) + 
                  ((aupay_result1.where("? > date", @start_date).length.to_f * (aupay_slmt_per_prev + @aupay_prev_inc_per)).round() * aupay_price) rescue 0
              aupay_result1_fin = aupay_result1_fin_prev_month
              if (person_hash["auPay現状売上1"] > aupay_result1_fin) || (Date.today > @closing_date)
                person_hash["auPay一次成果終着"] = person_hash["auPay現状売上1"]
              else  
                person_hash["auPay一次成果終着"] = aupay_result1_fin
              end 
        #PayPay
          paypay_user = Paypay.where(user_id: user.id)
          paypay_uq = paypay_user.where(date: @start_date..@end_date)
          # 現状売上
            # 一次成果
            paypay_result1 = paypay_user.where(status: "60審査可決").where(result_point: @start_done..@end_done)
            paypay_result1_profit = paypay_result1.sum(:profit)
            person_hash["PayPay獲得数"] = paypay_uq.length
            person_hash["PayPay第一成果件数"] = paypay_result1.length
            person_hash["PayPay現状売上"] = paypay_result1_profit
          # 終着売上
            # 一次成果
            paypay_data = paypay_user.where(date: @start_date..@end_date)
            paypay_len = paypay_data.length
            if paypay_len == 0
              paypay_len_ave = 0
            else 
              paypay_len_ave = (paypay_len.to_f / person_hash["消化新規シフト"]).round(1) rescue 0
            end 
            paypay_fin_len = (paypay_len_ave * person_hash["予定新規シフト"]).round() rescue 0 
            paypay_result1_fin = paypay_price * paypay_fin_len rescue 0
            if (paypay_result1_profit > paypay_result1_fin) || (Date.today >= @closing_date)
              paypay_result1_fin = paypay_result1_profit
            end 
            person_hash["PayPay一次成果終着"] = paypay_result1_fin
        # 楽天ペイ
          rakuten_pay_user = RakutenPay.where(user_id: user.id).where(status: "OK")
          # 一次成果
          rakuten_pay_uq = rakuten_pay_user.where(date: @start_date..@end_date)
          rakuten_pay_result1 = rakuten_pay_user.where(result_point: @rakuten_start..@rakuten_end)
          rakuten_pay_result1_len = rakuten_pay_result1.length 
          rakuten_pay_result1_profit = rakuten_pay_result1.sum(:profit)
          person_hash["楽天ペイ獲得数"] = rakuten_pay_uq.length
          person_hash["楽天ペイ第一成果件数"] = rakuten_pay_result1.length
          person_hash["楽天ペイ現状売上"] = rakuten_pay_result1_profit
          # 終着売上
          rakuten_pay_result1_prev = rakuten_pay_user.where(result_point: @rakuten_start.prev_month..@rakuten_end.prev_month)
          rakuten_pay_result1_prev_len = rakuten_pay_result1_prev.length
          rakuten_pay_result1_prev_profit = rakuten_pay_result1_prev.sum(:profit)
          if (rakuten_all_len >= rakuten_all_len_prev) || (Date.today >= @rakuten_change_date)
            rakuten_pay_result1_prev_profit = rakuten_pay_result1_profit
          end 
          person_hash["楽天ペイ一次成果終着"] = rakuten_pay_result1_prev_profit
        # AirPay
          results = Result.includes(:user,:result_cash).where(date: @start_date..@end_date)
          result_user = results.where(user_id: user.id)
          @result_airpay_sum = result_user.sum(:airpay)

            airpay_user = airpay_all.where(user_id: user.id)
            airpay_user_len = airpay_user.length
            airpay_len_ave = (airpay_user_len.to_f / person_hash["消化新規シフト"]).round(1) rescue 0

          # 一次成果
          airpay_user = 
            Airpay.where(user_id: user.id).where(status: "審査完了")
            .or(Airpay.where(user_id: user.id).where(status: "審査中"))
          airpay_result1 = airpay_user.where(status: "審査完了").where(result_point: @start_done..@end_done)
          airpay_result1_profit = airpay_result1.sum(:profit) + (airpay_result1.length * (airpay_price - 3000) )
          person_hash["AirPay第一成果件数"] = airpay_result1.length
          person_hash["AirPay現状売上"] = airpay_result1_profit
          # 終着
          @airpay_period_result_len = airpay_user.where(date: @start_date..@end_date).where(status: "審査完了").length
          @airpay_prev_val_len = 
            Airpay.where(user_id: user.id)
            .where(status: "審査中")
            .where("? > date",@start_date).length
          airpay_len_fin = 
            (
              (@result_airpay_sum - @airpay_period_result_len).to_f / 
              person_hash["消化新規シフト"] * 
              person_hash["予定新規シフト"] *
              (airpay_result_per - @airpay_dec_per)
            ).round() rescue 0
          airpay_prev_len_fin = (@airpay_prev_val_len * (airpay_result_per_prev - @airpay_prev_dec_per)).round() rescue 0
          airpay_period_fin = (airpay_len_fin * airpay_price) rescue 0
          airpay_prev_fin = (airpay_prev_len_fin * airpay_price) rescue 0
          airpay_maxsup_len = airpay_user.where(client: "マックス").length rescue 0
          airpay_result1_fin = 
            airpay_period_fin + airpay_prev_fin + 
            (
              (airpay_result1.length * (airpay_result_per + @airpay_inc_per)).round() * airpay_price
            ) - (airpay_maxsup_len * 2000) rescue 0
          if (airpay_result1_profit >= airpay_result1_fin) || (Date.today >= @closing_date)
            airpay_result1_fin = airpay_result1_profit
          end 
          person_hash["AirPay獲得数"] = @result_airpay_sum
          person_hash["AirPay終着獲得数"] = airpay_len_fin + airpay_result1.length + airpay_prev_len_fin
          person_hash["AirPay一次成果終着"] = airpay_result1_fin
          person_hash["過去月審査中案件"] = @airpay_prev_val_len
          person_hash["期間内成果率"] = ((airpay_result_per - @airpay_dec_per) * 100).round(1) 
          # person_hash["期間内計算式"] = "#{@result_airpay_sum - @airpay_period_result_len} / #{person_hash["消化新規シフト"]} * #{person_hash["予定新規シフト"]} * #{(airpay_result_per - @airpay_dec_per)}"
        # 出前館
          demaekan_user = Demaekan.where(user_id: user.id).where(status: "完了")
          # 一次成果
          demaekan_result1 = demaekan_user.where(first_cs_contract: @start_date..@end_date)
          demaekan_result1_profit = demaekan_result1.sum(:profit)
          person_hash["出前館第一成果件数"] = demaekan_result1.length
          person_hash["出前館現状売上"] = demaekan_result1_profit
          person_hash["出前館一次成果終着"] = demaekan_result1_profit
        # auステッカー
            au_sticker_user = OtherProduct.where(user_id: user.id).where(product_name: "auPay写真")
            au_sticker_result1 = au_sticker_user.where(date: @start_done.. @end_done)
            au_sticker_result1_profit = au_sticker_result1.sum(:profit)
            person_hash["auステッカー第一成果件数"] = au_sticker_result1.length
            person_hash["auステッカー現状売上"] = au_sticker_result1_profit
            person_hash["auステッカー一次成果終着"] = au_sticker_result1_profit
        # 現状売上
            # 新規
            profit_new = 
              person_hash["dメル現状売上1"] + person_hash["PayPay現状売上"] + person_hash["楽天ペイ現状売上"] +
              person_hash["AirPay現状売上"] + person_hash["出前館現状売上"] + person_hash["auステッカー現状売上"]
            person_hash["新規現状売上"] = profit_new
            # 決済
            profit_slmt = 
              person_hash["dメル現状売上2"] + person_hash["dメル現状売上3"] + person_hash["auPay現状売上1"]
            person_hash["決済現状売上"] = profit_slmt
            # 合計
              person_hash["合計現状売上"] = profit_new + profit_slmt
        # 終着売上
            # 新規
            profit_new_fin = 
              person_hash["dメル一次成果終着"] + person_hash["PayPay一次成果終着"] + person_hash["楽天ペイ一次成果終着"] +
              person_hash["AirPay一次成果終着"] + person_hash["出前館一次成果終着"] + person_hash["auステッカー一次成果終着"]
            person_hash["新規終着"] = profit_new_fin
            # 決済
            profit_slmt_fin = 
              person_hash["dメル二次成果終着"] + person_hash["dメル三次成果終着"] + person_hash["auPay一次成果終着"]
            person_hash["決済終着"] = profit_slmt_fin
            # 合計
              person_hash["合計終着"] = profit_new_fin + profit_slmt_fin

        # ハッシュへデータを配列へ格納
          @all_list << person_hash
          if (user.base_sub =="フェムト") && (user.position != "退職")
            @femto_list << person_hash
          elsif (user.base_sub =="サミット") && (user.position != "退職")
            @summit_list << person_hash
          elsif (base == "中部SS") && (user.position != "退職")
            @chubu_cash_list << person_hash
          elsif (base == "関西SS") && (user.position != "退職")
            @kansai_cash_list << person_hash
          elsif (base == "関東SS") && (user.position != "退職")
            @kanto_cash_list << person_hash
          elsif (base == "2次店") && (user.position != "退職")
            @partner_cash_list << person_hash
          elsif (user.position == "退職")
            @retire_list << person_hash
          end 
        end #ユーザーごとに繰り返す
      end # 拠点ごとに繰り返す
      @base_list = [@chubu_cash_list,@kansai_cash_list,@kanto_cash_list,@femto_list,@summit_list,@partner_cash_list,@retire_list]
  end 

end
