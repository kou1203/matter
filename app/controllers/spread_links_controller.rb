class SpreadLinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_month
  require 'google_drive'

  def index 
    @spread_links = SpreadLink.where(year: @month.year, month: @month.month)
    @results = 
      Result.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month).group(:user_id)
    @bases = 
      Result.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
      .where.not(user: {position: "退職"}).group(:base)
  end 

  def export
    days = ["日", "月", "火", "水", "木", "金", "土"] 
    @name = params[:name]
    @base = params[:base]
    @user_id = User.find_by(name: @name).id
    @spread_links = SpreadLink.where(year: @month.year, month: @month.month)
    @spread_link = @spread_links.find_by("name LIKE ?","%#{@base}%")
    @date_period = (@month.beginning_of_month.to_date..@month.end_of_month.to_date)
    # GoogleDriveのセッションを取得する
    @session = GoogleDrive::Session.from_config("config.json")
    @session_data = @session.spreadsheet_by_key(@spread_link.search_url).worksheet_by_title(@name)
    @results_all = Result.includes(:user,:result_cash).where(date: @date_period).where(shift: "キャッシュレス新規")
    @results = Result.includes(:user,:result_cash).where(user: {name: @name}).where(date: @date_period)
    index_cnt = 0
    col_cnt = 0
    # 終着内容
    col_cnt = 5
    if @results.where(shift: "キャッシュレス新規").present? # 新規シフトがある場合だけエクスポート
      @date_period.each do |r_date|
        index_cnt = 5 
        shift = Shift.includes(:user).where(user: {name: @name}).find_by(start_time: r_date)
        result = Result.includes(:user,:result_cash).where(user: {name: @name}).find_by(date: r_date)
        if shift.shift == "休み" || result.nil?
          @session_data[index_cnt,col_cnt] = shift.start_time.day
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = "（#{days[shift.start_time.wday]}）"
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = shift.shift.slice(-2,2)
          index_cnt += 1  
          col_cnt += 1
        else
          @session_data[index_cnt,col_cnt] = shift.start_time.day
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = "（#{days[shift.start_time.wday]}）"
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = shift.shift.slice(-2,2)
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.shift.slice(-2,2)
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.ojt.name rescue ""
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.area
          index_cnt += 2
          # 合計基準値
          @session_data[index_cnt,col_cnt] = result.first_total_visit.to_i + result.latter_total_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.first_visit.to_i + result.latter_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.first_interview.to_i + result.latter_interview.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.first_full_talk.to_i + result.latter_full_talk.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.first_get.to_i + result.latter_get.to_i
          index_cnt += 1
          # 前半基準値
          @session_data[index_cnt,col_cnt] = result.first_total_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.first_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.first_interview.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.first_full_talk.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.first_get.to_i
          index_cnt += 1
          # 後半基準値
          @session_data[index_cnt,col_cnt] = result.latter_total_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.latter_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.latter_interview.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.latter_full_talk.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.latter_get.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.cafe_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.cafe_get.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.other_food_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.other_food_get.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.car_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.car_get.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.other_retail_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.other_retail_get.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.hair_salon_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.hair_salon_get.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.manipulative_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.manipulative_get.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.other_service_visit.to_i
          index_cnt += 1
          @session_data[index_cnt,col_cnt] = result.other_service_get.to_i
          index_cnt += 1  
          # 切り返し
          if result.result_cash.present? 
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_01.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_01.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_01.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_02.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_02.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_02.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_03.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_03.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_03.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_04.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_04.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_04.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_05.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_05.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_05.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_06.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_06.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_06.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_07.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_07.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_07.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_08.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_08.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_08.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_09.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_09.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_09.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_10.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_10.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_10.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_11.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_11.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_11.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_12.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_12.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_12.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_13.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_13.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_13.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_19.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_19.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_19.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_18.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_18.to_i
            index_cnt += 1  
            @session_data[index_cnt,col_cnt] = result.result_cash.out_get_18.to_i
            index_cnt += 1  
          else  
            index_cnt += 45
          end 
          # 時間別基準値
          @session_data[index_cnt,col_cnt] = result.visit10.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.get10.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.visit11.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.get11.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.visit12.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.get12.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.visit13.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.get13.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.visit14.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.get14.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.visit15.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.get15.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.visit16.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.get16.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.visit17.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.get17.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.visit18.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.get18.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.visit19.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.get19.to_i
          index_cnt += 1  
          # 獲得商材
          @session_data[index_cnt,col_cnt] = Dmer.where(user_id: result.user_id).where(date: result.date).length rescue 0
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = Dmer.where(user_id: result.user_id).where(picture: result.date).length rescue 0
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = Dmer.where(user_id: result.user_id).where(settlement_second: result.date).length rescue 0
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = Aupay.where(user_id: result.user_id).where(date: result.date).length rescue 0
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = Aupay.where(user_id: result.user_id).where(picture: result.date).length rescue 0
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = Paypay.where(user_id: result.user_id).where(date: result.date).length rescue 0
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = RakutenPay.where(user_id: result.user_id).where(date: result.date).length rescue 0
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = Airpay.where(user_id: result.user_id).where(date: result.date).length rescue 0
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = UsenPay.where(user_id: result.user_id).where(date: result.date).length rescue 0
          index_cnt += 1  

          col_cnt += 1 # 列を一列ずらす
        end
      end 
      @date_progress = CashDateProgress.includes(:user).where(user: {name: @name}).where(date: @date_period).last
      @dmer_date_progress = DmerDateProgress.includes(:user).where(user: {name: @name}).where(date: @date_period).last
      @aupay_date_progress = AupayDateProgress.includes(:user).where(user: {name: @name}).where(date: @date_period).last
      @paypay_date_progress = PaypayDateProgress.includes(:user).where(user: {name: @name}).where(date: @date_period).last
      @rakuten_pay_date_progress = RakutenPayDateProgress.includes(:user).where(user: {name: @name}).where(date: @date_period).last
      @airpay_date_progress = AirpayDateProgress.includes(:user).where(user: {name: @name}).where(date: @date_period).last
      @demaekan_date_progress = DemaekanDateProgress.includes(:user).where(user: {name: @name}).where(date: @date_period).last
      @austicker_date_progress = AustickerDateProgress.includes(:user).where(user: {name: @name}).where(date: @date_period).last
      @dmersticker_date_progress = DmerstickerDateProgress.includes(:user).where(user: {name: @name}).where(date: @date_period).last
      @airpaysticker_date_progress = AirpaystickerDateProgress.includes(:user).where(user: {name: @name}).where(date: @date_period).last
      @dmers_val_len = @dmer_date_progress.get_len - @dmer_date_progress.def_len rescue 0
      @aupays_val_len = @aupay_date_progress.get_len - @aupay_date_progress.def_len rescue 0
      @rakuten_pays = RakutenPay.includes(:user).where(user: {name: @name}).where(date: @date_period)
      @rakuten_pay_val = 
        @rakuten_pays.where.not(status: "自社NG").where.not(status: "自社不備")
        .where(deficiency: nil)
        .or(
          RakutenPay.includes(:user).where(user: {name: @name}).where.not(status: "自社NG").where.not(status: "自社不備")
          .where.not(deficiency: nil)
          .where(share: @date_period)
          )
      # シフト内訳の現状売上と予測終着
      @session_data[8,41] = "売上更新最終日：#{@date_progress.create_date},作成日：#{Date.today}"
      @session_data[13,43] = @date_progress.valuation_current
      @session_data[13,45] = @date_progress.valuation_fin
      # 生産性
      @session_data[125,40] = @dmers_val_len
      @session_data[125,41] = @aupays_val_len
      @session_data[125,42] = @paypay_date_progress.get_len rescue 0
      @session_data[125,43] = @rakuten_pay_val.length rescue 0
      @session_data[125,44] = @airpay_date_progress.get_len rescue 0
      @session_data[125,45] = @usen_pay_date_progress.get_len rescue 0
      @session_data[127,40] = @dmer_date_progress.fin_len rescue 0
      @session_data[127,41] = @aupay_date_progress.fin_len rescue 0
      @session_data[127,42] = @paypay_date_progress.fin_len rescue 0
      @session_data[127,43] = @rakuten_pay_date_progress.fin_len rescue 0
      @session_data[127,44] = @airpay_date_progress.fin_len rescue 0
      # 現状売上・終着内訳
      # 成果になった件数
      @session_data[132,40] = @dmer_date_progress.done_len rescue 0
      @session_data[132,41] = @dmer_date_progress.result2_len rescue 0
      @session_data[132,42] = @dmer_date_progress.result3_len rescue 0
      @session_data[132,43] = @aupay_date_progress.result_len rescue 0
      @session_data[132,44] = @paypay_date_progress.result_len rescue 0
      @session_data[132,45] = @rakuten_pay_val.length rescue 0
      @session_data[132,46] = @airpay_date_progress.result_len rescue 0
      @session_data[132,47] = @demaekan_date_progress.result_len rescue 0
      # 現状売上
      @session_data[133,40] = @dmer_date_progress.valuation_current1 rescue 0
      @session_data[133,41] = @dmer_date_progress.valuation_current2 rescue 0
      @session_data[133,42] = @dmer_date_progress.valuation_current3 rescue 0
      @session_data[133,43] = @aupay_date_progress.valuation_current rescue 0
      @session_data[133,44] = @paypay_date_progress.valuation_current rescue 0
      @session_data[133,45] = @rakuten_pay_date_progress.valuation_current rescue 0
      @session_data[133,46] = @airpay_date_progress.valuation_current rescue 0
      @session_data[133,47] = @demaekan_date_progress.valuation_current rescue 0
      @session_data[133,48] = @austicker_date_progress.valuation_current + @dmersticker_date_progress.valuation_current + @airpaysticker_date_progress.valuation_current + @itss rescue 0
      @session_data[133,49] = @date_progress.valuation_current rescue 0
      # 終着見込
      @session_data[134,40] = @dmer_date_progress.valuation_fin1 rescue 0
      @session_data[134,41] = @dmer_date_progress.valuation_fin2 rescue 0
      @session_data[134,42] = @dmer_date_progress.valuation_fin3 rescue 0
      @session_data[134,43] = @aupay_date_progress.valuation_fin rescue 0
      @session_data[134,44] = @paypay_date_progress.valuation_fin rescue 0
      @session_data[134,45] = @rakuten_pay_date_progress.valuation_fin rescue 0
      @session_data[134,46] = @airpay_date_progress.valuation_fin rescue 0
      @session_data[134,47] = @demaekan_date_progress.valuation_fin rescue 0
      @session_data[134,48] = @austicker_date_progress.valuation_fin + @dmersticker_date_progress.valuation_fin + @airpaysticker_date_progress.valuation_fin + @itss rescue 0
      @session_data[134,49] = @date_progress.valuation_fin rescue 0
      # 獲得内訳
      @session_data[138,40] = @dmer_date_progress.get_len rescue 0
      @session_data[138,41] = @dmer_date_progress.def_len rescue 0
      @session_data[138,42] = @dmer_date_progress.get_len - @dmer_date_progress.def_len rescue 0
      @session_data[139,40] = @aupay_date_progress.get_len rescue 0
      @session_data[139,41] = @aupay_date_progress.def_len rescue 0
      @session_data[139,42] = @aupay_date_progress.get_len - @aupay_date_progress.def_len rescue 0
      @session_data[140,40] = @paypay_date_progress.get_len rescue 0
      @session_data[141,40] = @rakuten_pays.length rescue 0
      @session_data[141,41] = @rakuten_pays.length - @rakuten_pay_val.length rescue 0
      @session_data[141,42] = @rakuten_pay_val.length rescue 0
      @session_data[142,40] = @airpay_date_progress.get_len rescue 0
      @session_data[143,40] = @airpay_date_progress.get_len rescue 0
      # 決済内訳
      @dmers_slmt = 
      Dmer.where(settlementer_id: @user_id).where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      @dmers_slmt_done = @dmers_slmt.where(settlement: @date_period).where(status_settlement: "完了")
      @dmer_slmt2nd_done = 
      @dmers_slmt.where(settlement_second: @date_period)
      .where(status_settlement: "完了")
      .where(status_update_settlement: @date_period)
      .or(
        @dmers_slmt.where(settlement_second: @date_period)
        .where(status_settlement: "完了")
        .where(status_update_settlement: @date_period)
      )
      @dmers_slmt_def = @dmers_slmt.where(status_settlement: "決済不備")
      @dmers_slmt_pic_def = @dmers_slmt.where(status_settlement: "写真不備")
      @dmers_slmt2nd_done = @dmers_slmt.where(settlement_second: @date_period).where(status_settlement: "完了")
      @aupays_slmt = Aupay.where(settlementer_id: @user_id).where(status: "審査通過")
      @aupays_slmt_done = @aupays_slmt.where(settlement: @date_period).where(status_settlement: "完了")
      @aupays_slmt_def = @aupays_slmt.where(status_settlement: "決済不備")
      @aupays_slmt_pic_def = @aupays_slmt.where(status_settlement: "写真不備")
      @session_data[138,45] = @dmers_slmt_done.length rescue 0
      @session_data[138,46] = @dmers_slmt_def.length rescue 0
      @session_data[138,47] = @dmers_slmt_pic_def.length rescue 0
      @session_data[139,45] = @dmers_slmt2nd_done.length rescue 0
      @session_data[140,45] = @aupays_slmt_done.length rescue 0
      @session_data[140,46] = @aupays_slmt_def.length rescue 0
      @session_data[140,47] = @aupays_slmt_pic_def.length rescue 0

      # 週間基準値
      if @results.where(shift: "キャッシュレス新規").present?
        # 週毎の期間
        days = ["日", "月", "火", "水", "木", "金", "土"]
        if days[@month.beginning_of_month.wday] == "日" 
          week1 = (@month.beginning_of_month.since(1.days)) 
        elsif days[@month.beginning_of_month.wday] == "土" 
          week1 = (@month.beginning_of_month.ago(5.days))
        elsif days[@month.beginning_of_month.wday] == "金" 
          week1 = (@month.beginning_of_month.ago(4.days))
        elsif days[@month.beginning_of_month.wday] == "木" 
          week1 = (@month.beginning_of_month.ago(3.days)) 
        elsif days[@month.beginning_of_month.wday] == "水" 
          week1 = (@month.beginning_of_month.ago(2.days)) 
        elsif days[@month.beginning_of_month.wday] == "火" 
          week1 = (@month.beginning_of_month.ago(1.days)) 
        else 
          week1 = @month.beginning_of_month
        end
          @results_week = Result.includes(:result_cash).where(user_id: @user_id)
          @results_week1 = @results_week.where(date: week1..(week1.since(6.days)))
          @results_week2 = @results_week.where(date: (week1.since(7.days))..(week1.since(13.days)))
          @results_week3 = @results_week.where(date: (week1.since(14.days))..(week1.since(20.days)))
          @results_week4 = @results_week.where(date: (week1.since(21.days))..(week1.since(27.days)))
          @results_week5 = @results_week.where(date: (week1.since(28.days))..(week1.since(34.days)))
      end
      @weeks_arry = [@results_week1,@results_week2,@results_week3,@results_week4,@results_week5]
      week_cnt = 0
      week_index =149
      @weeks_arry.each do |week|
        week_col = 39
        dmer_len = week.sum(:dmer).to_f
        rakuten_pay_len = week.sum(:rakuten_pay).to_f
        airpay_len = week.sum(:airpay).to_f
        airpay_price = 
        if @results.sum(:airpay) >= 20
          8000
        elsif @results.sum(:airpay) >= 10
          6000
        else  
          3000
        end
        week_valuation = (dmer_len * 8000) + (rakuten_pay_len * 4000) + (airpay_len * airpay_price)
        @session_data[week_index + week_cnt,week_col] = "#{week.minimum(:date)}〜#{week.maximum(:date)}"
        week_col += 1
        @session_data[week_index + week_cnt,week_col] = week.where(shift: "キャッシュレス新規").length rescue 0 
        week_col += 1
        @session_data[week_index + week_cnt,week_col] = week_valuation rescue 0 
        week_col += 2
        @session_data[week_index + week_cnt,week_col] = dmer_len.to_f / week.where(shift: "キャッシュレス新規").length rescue 0 
        week_col += 1
        @session_data[week_index + week_cnt,week_col] = rakuten_pay_len.to_f / week.where(shift: "キャッシュレス新規").length rescue 0 
        week_col += 1
        @session_data[week_index + week_cnt,week_col] = airpay_len.to_f / week.where(shift: "キャッシュレス新規").length rescue 0 
        week_col += 1
        @session_data[week_index + week_cnt,week_col] = (week.sum(:first_visit).to_f + week.sum(:latter_visit).to_f) / week.where(shift: "キャッシュレス新規").length rescue 0
        week_col += 1
        @session_data[week_index + week_cnt,week_col] = (week.sum(:first_interview).to_f + week.sum(:latter_interview).to_f) / week.where(shift: "キャッシュレス新規").length rescue 0
        week_col += 2
        @session_data[week_index + week_cnt,week_col] = (week.sum(:first_full_talk).to_f + week.sum(:latter_full_talk).to_f) / week.where(shift: "キャッシュレス新規").length rescue 0
        week_col += 2
        @session_data[week_index + week_cnt,week_col] = (week.sum(:first_get).to_f + week.sum(:latter_get).to_f) / week.where(shift: "キャッシュレス新規").length rescue 0
        week_cnt += 1
      end 
      # 全拠点基準値
      s_index = 18 
      s_col = 47
      # 全拠点の消化シフト
      @session_data[10,48] = @results_all.length
      @session_data[10,49] = @results_all.group(:user_id).length
      # 合計
      @session_data[s_index,s_col] = @results_all.sum(:first_total_visit) + @results_all.sum(:latter_total_visit)
      @session_data[s_index + 1,s_col] = @results_all.sum(:first_visit) + @results_all.sum(:latter_visit)
      @session_data[s_index + 2,s_col] = @results_all.sum(:first_interview) + @results_all.sum(:latter_interview)
      @session_data[s_index + 3,s_col] = @results_all.sum(:first_full_talk) + @results_all.sum(:latter_full_talk)
      @session_data[s_index + 4,s_col] = @results_all.sum(:first_get) + @results_all.sum(:latter_get)
      # 平均
      @session_data[s_index,s_col + 1] = ((@results_all.sum(:first_total_visit) + @results_all.sum(:latter_total_visit)).to_f / @results_all.length).round(1)
      @session_data[s_index + 1,s_col + 1] = ((@results_all.sum(:first_visit) + @results_all.sum(:latter_visit)).to_f / @results_all.length).round(1)
      @session_data[s_index + 2,s_col + 1] = ((@results_all.sum(:first_interview) + @results_all.sum(:latter_interview)).to_f / @results_all.length).round(1)
      @session_data[s_index + 3,s_col + 1] = ((@results_all.sum(:first_full_talk) + @results_all.sum(:latter_full_talk)).to_f / @results_all.length).round(1)
      @session_data[s_index + 4,s_col + 1] = ((@results_all.sum(:first_get) + @results_all.sum(:latter_get)).to_f / @results_all.length).round(1)
      # 比率
      @session_data[s_index,s_col + 2] = "-"
      @session_data[s_index + 1,s_col + 2] = 
        "#{((@results_all.sum(:first_visit) + @results_all.sum(:latter_visit)).to_f / (@results_all.sum(:first_total_visit) + @results_all.sum(:latter_total_visit)) * 100).round()}%"
      @session_data[s_index + 2,s_col + 2] = 
        "#{((@results_all.sum(:first_interview) + @results_all.sum(:latter_interview)).to_f / (@results_all.sum(:first_visit) + @results_all.sum(:latter_visit)) * 100).round()}%"
      @session_data[s_index + 3,s_col + 2] = 
        "#{((@results_all.sum(:first_full_talk) + @results_all.sum(:latter_full_talk)).to_f / (@results_all.sum(:first_interview) + @results_all.sum(:latter_interview)) * 100).round()}%"
      @session_data[s_index + 4,s_col + 2] = 
      "#{((@results_all.sum(:first_get) + @results_all.sum(:latter_get)).to_f / (@results_all.sum(:first_full_talk) + @results_all.sum(:latter_full_talk)) * 100).round()}%"
      # 前半合計
      @session_data[s_index + 5,s_col] = @results_all.sum(:first_total_visit)
      @session_data[s_index + 6,s_col] = @results_all.sum(:first_visit)
      @session_data[s_index + 7,s_col] = @results_all.sum(:first_interview)
      @session_data[s_index + 8,s_col] = @results_all.sum(:first_full_talk)
      @session_data[s_index + 9,s_col] = @results_all.sum(:first_get)
      # 後半合計
      @session_data[s_index + 10,s_col] = @results_all.sum(:latter_total_visit)
      @session_data[s_index + 11,s_col] = @results_all.sum(:latter_visit)
      @session_data[s_index + 12,s_col] = @results_all.sum(:latter_interview)
      @session_data[s_index + 13,s_col] = @results_all.sum(:latter_full_talk)
      @session_data[s_index + 14,s_col] = @results_all.sum(:latter_get)

      # 店舗別基準値
      store_index = 37 
      store_col = 47
      # 合計
      @session_data[store_index,store_col] = @results_all.sum(:cafe_visit)
      @session_data[store_index + 1,store_col] = @results_all.sum(:cafe_get)
      @session_data[store_index + 2,store_col] = @results_all.sum(:other_food_visit)
      @session_data[store_index + 3,store_col] = @results_all.sum(:other_food_get)
      @session_data[store_index + 4,store_col] = @results_all.sum(:car_visit)
      @session_data[store_index + 5,store_col] = @results_all.sum(:car_get)
      @session_data[store_index + 6,store_col] = @results_all.sum(:other_retail_visit)
      @session_data[store_index + 7,store_col] = @results_all.sum(:other_retail_get)
      @session_data[store_index + 8,store_col] = @results_all.sum(:hair_salon_visit)
      @session_data[store_index + 9,store_col] = @results_all.sum(:hair_salon_get)
      @session_data[store_index + 10,store_col] = @results_all.sum(:manipulative_visit)
      @session_data[store_index + 11,store_col] = @results_all.sum(:manipulative_get)
      @session_data[store_index + 12,store_col] = @results_all.sum(:other_service_visit)
      @session_data[store_index + 13,store_col] = @results_all.sum(:other_service_get)

      # 全拠点切り返し
      out_index = 55 
      out_col = 47
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_01)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_01)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_01)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_02)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_02)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_02)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_03)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_03)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_03)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_04)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_04)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_04)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_05)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_05)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_05)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_06)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_06)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_06)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_07)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_07)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_07)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_08)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_08)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_08)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_09)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_09)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_09)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_10)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_10)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_10)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_11)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_11)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_11)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_12)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_12)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_12)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_13)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_13)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_13)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_interview_19)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_full_talk_19)
      out_index += 1
      @session_data[out_index,out_col] = @results_all.sum(:out_get_19)

      # 全拠点時間別基準値
      time_index = 101 
      time_col = 47
      @session_data[time_index,time_col] = @results_all.sum(:visit10)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:get10)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:visit11)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:get11)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:visit12)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:get12)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:visit13)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:get13)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:visit14)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:get14)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:visit15)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:get15)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:visit16)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:get16)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:visit17)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:get17)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:visit18)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:get18)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:visit19)
      time_index += 1
      @session_data[time_index,time_col] = @results_all.sum(:get19)
      time_index += 1

      @session_data.save
      redirect_to spread_links_path(month: @month), alert: "#{@name}のスプレッドへ書き込みました！"
    else # 新規シフトがない場合の処理
      redirect_to spread_links_path(month: @month), alert: "#{@name}の新規シフトの入力がありません。"
    end # 新規シフトがある場合だけエクスポート

  end 

  def base_export
    # 初期情報
      @base = params[:base]
      @users = User.where(base: @base).where(base_sub: "キャッシュレス").where.not(position: "退職")
      @spread_links = SpreadLink.where(year: @month.year, month: @month.month)
      @spread_link = @spread_links.find_by("name LIKE ?","%#{@base}%")
      @session = GoogleDrive::Session.from_config("config.json")
      @session_data = @session.spreadsheet_by_key(@spread_link.search_url).worksheet_by_title("拠点利益表")
    # 初期情報
    # 基準値
      index_cnt = 6
      @users.each do |user|
        col_cnt = 2
        # 基本情報
        @shifts = Shift.where(user_id: user.id).where(start_time: @month.all_month)
        @results = Result.where(user_id: user.id).where(date: @month.all_month)
        @date_progress = CashDateProgress.includes(:user).where(user_id: user.id).where(date: @month.all_month).last
        @dmer_date_progress = DmerDateProgress.includes(:user).where(user_id: user.id).where(date: @month.all_month).last
        @aupay_date_progress = AupayDateProgress.includes(:user).where(user_id: user.id).where(date: @month.all_month).last
        @paypay_date_progress = PaypayDateProgress.includes(:user).where(user_id: user.id).where(date: @month.all_month).last
        @rakuten_pay_date_progress = RakutenPayDateProgress.includes(:user).where(user_id: user.id).where(date: @month.all_month).last
        @airpay_date_progress = AirpayDateProgress.includes(:user).where(user_id: user.id).where(date: @month.all_month).last
        @itss_date_progress = OtherProductDateProgress.includes(:user).where(product_name: "ITSS").where(user_id: user.id).where(date: @month.all_month).last
        @usen_pay_date_progress = OtherProductDateProgress.includes(:user).where(product_name: "UsenPay").where(user_id: user.id).where(date: @month.all_month).last
        @session_data[index_cnt,col_cnt] = user.name
        @session_data[27 + index_cnt,col_cnt] = user.name
        col_cnt += 1
        @session_data[index_cnt,col_cnt] = user.position_sub
        @session_data[27 + index_cnt,col_cnt] = user.position_sub
        col_cnt += 3
        # 基本情報
        # シフト
        @session_data[index_cnt,col_cnt] = @shifts.where(shift: "キャッシュレス新規").length  rescue 0
        @session_data[27 + index_cnt,col_cnt - 2] = @shifts.where(shift: "キャッシュレス新規").length  rescue 0
        col_cnt += 1
        @session_data[index_cnt,col_cnt] = @results.where(shift: "キャッシュレス新規").length  rescue 0
        @session_data[27 + index_cnt,col_cnt - 2] = @results.where(shift: "キャッシュレス新規").length rescue 0
        col_cnt += 1
        @session_data[index_cnt,col_cnt] = @shifts.where(shift: "キャッシュレス決済").length rescue 0
        col_cnt += 1
        @session_data[index_cnt,col_cnt] = @results.where(shift: "キャッシュレス決済").length rescue 0
        # シフト
        # 売上
        col_cnt += 2
        @session_data[index_cnt,col_cnt] = @date_progress.valuation_current  rescue 0
        col_cnt += 1
        @session_data[index_cnt,col_cnt] = @date_progress.valuation_fin  rescue 0
        col_cnt += 1
        # 売上
        # 基準値
        @session_data[index_cnt,col_cnt] = ((@results.sum(:first_total_visit) + @results.sum(:latter_total_visit)).to_f / @results.where(shift: "キャッシュレス新規").length).round(1)  rescue 0
        col_cnt += 1
        @session_data[index_cnt,col_cnt] = ((@results.sum(:first_visit) + @results.sum(:latter_visit)).to_f / @results.where(shift: "キャッシュレス新規").length).round(1)  rescue 0
        col_cnt += 2
        @session_data[index_cnt,col_cnt] = ((@results.sum(:first_interview) + @results.sum(:latter_interview)).to_f / @results.where(shift: "キャッシュレス新規").length).round(1)  rescue 0
        col_cnt += 2
        @session_data[index_cnt,col_cnt] = ((@results.sum(:first_full_talk) + @results.sum(:latter_full_talk)).to_f / @results.where(shift: "キャッシュレス新規").length).round(1)  rescue 0
        col_cnt += 2
        @session_data[index_cnt,col_cnt] = ((@results.sum(:first_get) + @results.sum(:latter_get)).to_f / @results.where(shift: "キャッシュレス新規").length).round(1)  rescue 0
        col_cnt += 2
        # 基準値
        # 生産性
        col_cnt = 7
        @session_data[27 + index_cnt,col_cnt] = @dmer_date_progress.get_len rescue 0
        col_cnt += 1
        @session_data[27 + index_cnt,col_cnt] = @dmer_date_progress.def_len rescue 0
        col_cnt += 3
        @session_data[27 + index_cnt,col_cnt] = @aupay_date_progress.get_len rescue 0
        col_cnt += 3
        @session_data[27 + index_cnt,col_cnt] = @rakuten_pay_date_progress.get_len rescue 0
        col_cnt += 3
        @session_data[27 + index_cnt,col_cnt] = @airpay_date_progress.get_len rescue 0
        col_cnt += 2
        @session_data[27 + index_cnt,col_cnt] = @paypay_date_progress.get_len rescue 0
        col_cnt += 1
        @session_data[27 + index_cnt,col_cnt] = @itss_date_progress.get_len rescue 0
        col_cnt += 1
        # 生産性
        # 成果になった件数
        @session_data[27 + index_cnt,col_cnt] = @dmer_date_progress.done_len rescue 0
        col_cnt += 1
        @session_data[27 + index_cnt,col_cnt] = @dmer_date_progress.result2_len rescue 0
        col_cnt += 1
        @session_data[27 + index_cnt,col_cnt] = @dmer_date_progress.result3_len rescue 0
        col_cnt += 1
        @session_data[27 + index_cnt,col_cnt] = @aupay_date_progress.result_len rescue 0
        col_cnt += 1
        @session_data[27 + index_cnt,col_cnt] = @rakuten_pay_date_progress.get_len rescue 0
        col_cnt += 1
        @session_data[27 + index_cnt,col_cnt] = @airpay_date_progress.result_len rescue 0
        col_cnt += 1
        @session_data[27 + index_cnt,col_cnt] = @paypay_date_progress.result_len rescue 0
        col_cnt += 1
        @session_data[27 + index_cnt,col_cnt] = @itss_date_progress.result_len rescue 0
        col_cnt += 1
        @session_data[27 + index_cnt,col_cnt] = @usen_pay_date_progress.get_len rescue 0
        col_cnt += 1
        # 成果になった件数
        index_cnt += 1
      end 
    # 基準値
    # リダイレクト先
      @session_data.save
      redirect_to spread_links_path(month: @month), alert: "#{@base}の拠点利益表のスプレッドへ書き込みました！"
    # リダイレクト先
  end 

  def new 
    @spread_link = SpreadLink.new
  end 

  def create 
    @spread_link = SpreadLink.new(spread_links_params)
    if @spread_link.save 
      flash[:notice] = "スプレッド情報を保存しました。"
      redirect_to spread_links_path(month: @month)
    else 
    end 
  end 

  def edit 
    @spread_link = SpreadLink.find(params[:id])
  end 
  
  def update 
    @spread_link = SpreadLink.find(params[:id])
    @spread_link.update(spread_links_params)
    redirect_to spread_links_path(month: @month)
  end 
  
  def show 
  end 

  private 
  def spread_links_params
    params.require(:spread_link).permit(
      :year,
      :month,
      :name,
      :original_url,
      :search_url,
    )
  end
  
  def set_month
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
  end 
  
end
