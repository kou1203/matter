class UsersController < ApplicationController
  def index 
    @q = User.ransack(params[:q])
    @users = 
      if params[:q].nil? 
        User.none 
      else    
        @q.result(distinct: false)
      end
  end 

  def new 
    @user = User.new 
  end 
  
  def create 
    @user = User.new(user_params)
    if @user.save 
      redirect_to user_path , alert: "#{@user.name}の登録が完了しました"
    else  
      render new 
    end 
  end 

  def edit 
    @user = User.find(params[:id])
  end 
  
  def update 
    p user_params
    @user = User.find(params[:id])
    @user.update(user_params)
      redirect_to users_path ,alert: "情報の更新をしました。"
  end 

  def show 
    @shifts = Shift.includes(:user).all
    @user = User.find(params[:id])
    @shift = @shifts.where(user_id: @user.id)
    # 月間増減
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    # dメル
    @dmers = Dmer.includes(:store_prop).where(date: @month.all_month).where(user_id: @user.id).where(store_prop: {head_store: nil})
    @dmers_inc = 
      Dmer.includes(:store_prop).where.not(date: @month.all_month)
      .where(user_id: @user.id).where(store_prop: {head_store: nil})
      .where(status: "審査OK").where.not(industry_status: "×").where.not(industry_status: "NG")
      .where(result_point: @month.all_month)
    @dmers_dec = 
      Dmer.includes(:store_prop).where(date: @month.all_month)
      .where(user_id: @user.id).where(store_prop: {head_store: nil})
      .where(status: "審査OK").where.not(industry_status: "×").where.not(industry_status: "NG")
      .where.not(result_point: @month.all_month)
    @dmer_db = Dmer.includes(:store_prop).where(share: @month.all_month).where(user_id: @user.id)

    @aupays = Aupay.includes(:store_prop).where(date: @month.all_month).where(user_id: @user.id).where(store_prop: {head_store: nil})
    @aupays_inc = 
      Aupay.includes(:store_prop).where(result_point: @month.all_month).where(user_id: @user.id)
      .where(store_prop: {head_store: nil}).where.not(date: @month.all_month).where(status: "審査通過")
    @aupays_dec = 
      Aupay.includes(:store_prop).where.not(result_point: @month.all_month).where(user_id: @user.id)
      .where(store_prop: {head_store: nil}).where(date: @month.all_month).where(status: "審査通過")

    @rakuten_pays = RakutenPay.includes(:store_prop).where(date: @month.all_month).where(user_id: @user.id)
    @rakuten_pays_inc = 
      RakutenPay.includes(:store_prop)
      .where.not(date: @month.all_month).where(user_id: @user.id)
      .where(share: @month.all_month).where.not(deficiency: nil)
    @rakuten_pays_dec = RakutenPay.includes(:store_prop).where(date: @month.all_month).where(user_id: @user.id)
    .where.not(share: @month.all_month).where.not(deficiency: nil)
    # 決済リスト
    @slmts = 
      StoreProp.includes(:dmer, :aupay, :comments).where(aupay: {share: Date.today.ago(3.month)..Date.today})
      .or(
        StoreProp.includes(:dmer, :aupay, :comments).where(dmer: {share: Date.today.ago(3.month)..Date.today})
      ).order(:id)
    # 不備リスト
    @dmers_def = 
      Dmer.includes(:store_prop, :user)
      .where(status: "不備対応中")
      .where(date: Date.today.ago(2.month)..Date.today)
      .where(user_id: @user.id)

    @aupays_def = 
      Aupay.includes(:store_prop, :user)
      .where(status: "差し戻し")
      .where.not(deficiency_remarks: "既存auPAY加盟店の登録がすでにあるため、差し戻しさせていただきます。")
      .where(date: Date.today.ago(3.month)..Date.today)
      .where(user_id: @user.id)

    @rakuten_pays_def = 
      RakutenPay.includes(:store_prop, :user)
      .where(status: "自社不備")
      .where(user_id: @user.id)
      .or(
        RakutenPay.includes(:store_prop, :user)
        .where(status: "1次審査不備")
        .where(user_id: @user.id)
      )
    # 利益表

    @minimum_date_cash = @month.prev_month.beginning_of_month.since(25.days)
    @maximum_date_cash = @month.beginning_of_month.since(24.days)
    @results = Result.where(user_id: @user.id).where(date: @minimum_date_cash..@maximum_date_cash).order(:date)
    @results_date = @results.select(:date, :user_id, :shift,:profit)
    @results_date_min = @results_date.minimum(:date)
    @results_date_max = @results_date.maximum(:date)
    @results_out = @results.includes(:result_cash).select(:result_cash_id)
    # 予定シフト変数 
      @result_shift = 
        @shift.where(start_time: @minimum_date_cash..@maximum_date_cash) rescue nil
      if @result_shift.blank?
      else
      @result_shift_min = @result_shift.minimum(:start_time)
      @result_shift_max = @result_shift.maximum(:start_time) 

      @new_shift = @result_shift.where(shift: "キャッシュレス新規").length 
      @settlement_shift = @result_shift.where(shift: "キャッシュレス決済").length 
      @summit_shift = @result_shift.where(shift: "サミット").length 
      @casa_shift = @result_shift.where(shift: "楽天フェムト新規").length 
      @casa_put_shift= @result_shift.where(shift: "楽天フェムト設置").length 
      @ojt_shift = @result_shift.where(shift: "帯同").length 
      @house_work_shift = @result_shift.where(shift: "内勤").length
      end
      # 消化シフト変数
      @digestion_new = @results_date.where(shift: "キャッシュレス新規").length
      @digestion_settlement = @results_date.where(shift: "キャッシュレス決済").length
      @digestion_summit = @results_date.where(shift: "サミット").length
      @digestion_casa = @results_date.where(shift: "楽天フェムト新規").length
      @digestion_casa_put = @results_date.where(shift: "楽天フェムト設置").length
      @digestion_ojt = @results_date.where(shift: "帯同").length
      @digestion_house_work = @results_date.where(shift: "内勤").length
      #  合計変数 
       @sum_visit = @results.where(shift: "キャッシュレス新規").sum("first_visit + latter_visit") 
       @sum_interview = @results.where(shift: "キャッシュレス新規").sum("first_interview + latter_interview") 
       @sum_full_talk = @results.where(shift: "キャッシュレス新規").sum("first_full_talk + latter_full_talk") 
       @sum_get = @results.where(shift: "キャッシュレス新規").sum("first_get + latter_get") 
      #  前半変数 
       @sum_visit_f = @results.where(shift: "キャッシュレス新規").sum(:first_visit) 
       @sum_interview_f = @results.where(shift: "キャッシュレス新規").sum(:first_interview) 
       @sum_full_talk_f = @results.where(shift: "キャッシュレス新規").sum(:first_full_talk) 
       @sum_get_f = @results.where(shift: "キャッシュレス新規").sum(:first_get) 
      # 後半変数 
       @sum_visit_l = @results.where(shift: "キャッシュレス新規").sum(:latter_visit) 
       @sum_interview_l = @results.where(shift: "キャッシュレス新規").sum(:latter_interview) 
       @sum_full_talk_l = @results.where(shift: "キャッシュレス新規").sum(:latter_full_talk) 
       @sum_get_l = @results.where(shift: "キャッシュレス新規").sum(:latter_get) 
       # 店舗別合計変数 
        @cafe_visit_sum = @results.where(shift: "キャッシュレス新規").sum(:cafe_visit) 
        @cafe_get_sum = @results.where(shift: "キャッシュレス新規").sum(:cafe_get) 
        @other_food_visit_sum = @results.where(shift: "キャッシュレス新規").sum(:other_food_visit) 
        @other_food_get_sum = @results.where(shift: "キャッシュレス新規").sum(:other_food_get) 
        @car_visit_sum = @results.where(shift: "キャッシュレス新規").sum(:car_visit) 
        @car_get_sum = @results.where(shift: "キャッシュレス新規").sum(:car_get) 
        @other_retail_visit_sum = @results.where(shift: "キャッシュレス新規").sum(:other_retail_visit) 
        @other_retail_get_sum = @results.where(shift: "キャッシュレス新規").sum(:other_retail_get) 
        @hair_salon_visit_sum = @results.where(shift: "キャッシュレス新規").sum(:hair_salon_visit) 
        @hair_salon_get_sum = @results.where(shift: "キャッシュレス新規").sum(:hair_salon_get) 
        @manipulative_visit_sum = @results.where(shift: "キャッシュレス新規").sum(:manipulative_visit) 
        @manipulative_get_sum = @results.where(shift: "キャッシュレス新規").sum(:manipulative_get) 
        @other_service_visit_sum = @results.where(shift: "キャッシュレス新規").sum(:other_service_visit) 
        @other_service_get_sum = @results.where(shift: "キャッシュレス新規").sum(:other_service_get) 
       # 全店舗合計変数 
        @store_visit_sum = @cafe_visit_sum +  @other_food_visit_sum + @car_visit_sum + @other_retail_visit_sum + @hair_salon_visit_sum + @manipulative_visit_sum + @other_service_visit_sum 
        @store_get_sum = @cafe_get_sum +  @other_food_get_sum + @car_get_sum + @other_retail_get_sum + @hair_salon_get_sum + @manipulative_get_sum + @other_service_get_sum 
      # 時間別基準値合計
        @visit10_sum = @results.sum(:visit10)
        @visit10_ave = @results.average(:visit10)
        @get10_sum = @results.sum(:get10)
        @get10_ave = @results.average(:get10)

        @visit11_sum = @results.sum(:visit11)
        @visit11_ave = @results.average(:visit11)
        @get11_sum = @results.sum(:get11)
        @get11_ave = @results.average(:get11)

        @visit12_sum = @results.sum(:visit12)
        @visit12_ave = @results.average(:visit12)
        @get12_sum = @results.sum(:get12)
        @get12_ave = @results.average(:get12)

        @visit13_sum = @results.sum(:visit13)
        @visit13_ave = @results.average(:visit13)
        @get13_sum = @results.sum(:get13)
        @get13_ave = @results.average(:get13)

        @visit14_sum = @results.sum(:visit14)
        @visit14_ave = @results.average(:visit14)
        @get14_sum = @results.sum(:get14)
        @get14_ave = @results.average(:get14)

        @visit15_sum = @results.sum(:visit15)
        @visit15_ave = @results.average(:visit15)
        @get15_sum = @results.sum(:get15)
        @get15_ave = @results.average(:get15)

        @visit16_sum = @results.sum(:visit16)
        @visit16_ave = @results.average(:visit16)
        @get16_sum = @results.sum(:get16)
        @get16_ave = @results.average(:get16)

        @visit17_sum = @results.sum(:visit17)
        @visit17_ave = @results.average(:visit17)
        @get17_sum = @results.sum(:get17)
        @get17_ave = @results.average(:get17)

        @visit18_sum = @results.sum(:visit18)
        @visit18_ave = @results.average(:visit18)
        @get18_sum = @results.sum(:get18)
        @get18_ave = @results.average(:get18)

        @visit19_sum = @results.sum(:visit19)
        @visit19_ave = @results.average(:visit19)
        @get19_sum = @results.sum(:get19)
        @get19_ave = @results.average(:get19)

        @time_visit_sum = [@visit10_sum,@visit11_sum,@visit12_sum,@visit13_sum,@visit14_sum,@visit15_sum,@visit16_sum,@visit17_sum,@visit18_sum,@visit19_sum]
        @time_visit_ave = [@visit10_ave,@visit11_ave,@visit12_ave,@visit13_ave,@visit14_ave,@visit15_ave,@visit16_ave,@visit17_ave,@visit18_ave,@visit19_ave]
        @time_get_sum = [@get10_sum,@get11_sum,@get12_sum,@get13_sum,@get14_sum,@get15_sum,@get16_sum,@get17_sum,@get18_sum,@get19_sum]
        @time_get_ave = [@get10_ave,@get11_ave,@get12_ave,@get13_ave,@get14_ave,@get15_ave,@get16_ave,@get17_ave,@get18_ave,@get19_ave]
    if @results.present?
      # 週毎の期間
      days = ["日", "月", "火", "水", "木", "金", "土"]
      start_date = Date.new(@results.minimum(:date).year,@results.minimum(:date).month,26)
       if days[start_date.wday] == "日" 
         week1 = (start_date + 1) 
       elsif days[start_date.wday] == "土" 
         week1 = (start_date - 5)
       elsif days[start_date.wday] == "金" 
         week1 = (start_date - 4)
       elsif days[start_date.wday] == "木" 
         week1 = (start_date - 3) 
       elsif days[start_date.wday] == "水" 
         week1 = (start_date - 2) 
       elsif days[start_date.wday] == "火" 
         week1 = (start_date - 1) 
       end 
       if @results_date.minimum(:date).month == @results_date.maximum(:date).prev_month.month
        @results_week1 = Result.where(user_id: @user.id).where(date: week1..(week1+6))
        @results_week2 = Result.where(user_id: @user.id).where(date: (week1+7)..(week1+13))
        @results_week3 = Result.where(user_id: @user.id).where(date: (week1+14)..(week1+20))
        @results_week4 = Result.where(user_id: @user.id).where(date: (week1+21)..(week1+27))
        @results_week5 = Result.where(user_id: @user.id).where(date: (week1+28)..(week1+34))
       end
      #  営業打ち込み売上
       @sales_new_profit_sum = @results.where(shift: "キャッシュレス新規").sum(:profit)
       @sales_new_profit_ave = @results.where(shift: "キャッシュレス新規").average(:profit)
       @sales_new_profit_fin = @sales_new_profit_ave * @new_shift rescue 0
       @sales_slmt_profit_sum = @results.where(shift: "キャッシュレス決済").sum(:profit)
       @sales_slmt_profit_ave = @results.where(shift: "キャッシュレス決済").average(:profit)
       @sales_slmt_profit_fin = @sales_slmt_profit_ave * @settlement_shift rescue 0
       @sales_profit_fin = @sales_new_profit_fin + @sales_slmt_profit_fin
       @sales_profit_ave = @sales_profit_fin / (@new_shift + @settlement_shift) rescue 0
       @sales_profit_ojt_ave = (@sales_new_profit_sum + @sales_slmt_profit_sum) / (@new_shift + @settlement_shift) rescue 0
       @sales_profit_ojt_sum = @sales_profit_ojt_ave * @digestion_ojt rescue 0
      #  dメル
       @dmer_user = 
        Dmer.includes(:store_prop).where(user_id: @results.first.user_id )
        .select(:valuation_new, :industry_status, :user_id, :store_prop_id)
        @dmer_uq = 
        this_period(@dmer_user,@results_date)
        .where(store_prop: {head_store: nil}).select(:valuation_new, :industry_status, :user_id, :store_prop_id)
        @dmer_db_data = 
        share_period(@dmer_user,@results_date).where.not(store_prop: {head_store: nil})
        .where.not(industry_status: "×").where.not(industry_status: "NG").where.not(industry_status: "要確認")
        .where(status: "審査OK").select(:valuation_new, :industry_status, :user_id, :store_prop_id,:date,:result_point,:status,:industry_status,:share)
        @dmer_def = dmer_def(@dmer_uq, @results_date).select(:valuation_new, :industry_status, :user_id, :date,:status,:result_point,:store_prop_id)
        @dmer_inc = 
        judge_inc(@dmer_user,@results_date)
        .where(store_prop: {head_store: nil})
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status: "審査OK")
        .select(:valuation_new, :industry_status, :user_id, :store_prop_id,:date,:result_point,:status,:deficiency_remarks)
        @dmer_dec = 
        judge_dec(@dmer_user,@results_date)
        .where.not(industry_status: "NG").where.not(industry_status: "×")
        .select(:id,:valuation_new, :industry_status, :user_id, :store_prop_id,:date,:result_point, :status) 
        # dメル第一成果, 期間月初〜月末
        # ①月内に審査完了＆決済が月末より前に完了している
        # ②審査完了は過去月＆決済は月内に完了している
        @dmer_done =  
          @dmer_user.where(result_point: @month.beginning_of_month..@month.end_of_month)
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status: "審査OK")
          .where("? >= settlement", @month.end_of_month)
          .or(
            @dmer_user.where(settlement: @month.beginning_of_month..@month.end_of_month)
            .where.not(industry_status: "NG")
            .where.not(industry_status: "×")
            .where.not(industry_status: "要確認")
            .where(status: "審査OK")
            .where("? >= result_point", @month.end_of_month)
          ).select(:valuation_settlement, :industry_status, :user_id, :store_prop_id,:date,:result_point,:status,:id,:status_update_settlement,:settlement_second)
          
        # 決済
        @dmer_slmter = 
          Dmer.where(settlementer_id: @results.first.user_id)
        @dmer_slmt = 
        slmt_period(@dmer_slmter, @results_date)
        .where.not(industry_status: "×")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "要確認")
        .select(:valuation_settlement, :industry_status, :user_id, :store_prop_id)
        @dmer_ok =
          @dmer_slmter.where(status: "審査OK")
          .where.not(industry_status: "×")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "要確認")
          .or(
            @dmer_slmter.where(industry_status: nil)
          )
        @dmer_slmt_def = @dmer_ok.where(picture: @results_date_min..@results_date_max).where(settlement: nil).where("settlement_deadline > ?",Date.today)
        @dmer_pic_def = @dmer_ok.where(settlement: @results_date_min..@results_date_max).where(picture: nil).where("settlement_deadline > ?",Date.today)

        @dmer_slmt_done = 
          @dmer_slmter.where(status_update_settlement: @month.beginning_of_month..@month.end_of_month)
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status: "審査OK")
          .where(status_settlement: "完了")
          .select(:valuation_settlement, :industry_status, :user_id, :store_prop_id,:date,:result_point,:status,:id,:status_update_settlement,:settlement_second)
        @dmer_pic_def = @dmer_slmt.where(picture: nil)
        @dmer_slmt2nd_get = 
          slmt2nd_get(@dmer_slmter,@results_date)
          .select(:valuation_second_settlement, :industry_status, :user_id, :store_prop_id)
        @dmer_slmt2nd = 
          slmt_second(@dmer_slmter,@results_date)
          .select(:valuation_second_settlement, :industry_status, :user_id, :store_prop_id)
          @dmer_slmt2nd_done = 
          @dmer_slmter.where(settlement_second: @month.beginning_of_month..@month.end_of_month)
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status: "審査OK")
          .where(status_settlement: "完了")
          .select(:valuation_second_settlement, :industry_status, :user_id, :store_prop_id,:date,:result_point,:status,:id,:status_update_settlement,:settlement_second)
        # 決済対象 
        @dmers_slmt_target = 
          slmt_dead_line(@dmer_user,@results_date)
          .where.not(industry_status: "NG").where.not(industry_status: "×").where.not(industry_status: "要確認")
          .or(slmt_dead_line(@dmer_slmter, @results_date)
          .where(industry_status: nil)).select(:valuation_settlement)
        @dmer_slmt2nd_target = slmt2nd_dead_line(@dmer_user,@results_date).select(:valuation_second_settlement)
      # auPay
      @aupay_user = 
        Aupay.includes(:store_prop).where(user_id: @results.first.user_id)
        .select(:valuation_new, :user_id, :store_prop_id)
      @aupay_uq = 
        this_period(@aupay_user,@results_date)
        .where(store_prop: {head_store: nil}).select(:valuation_new, :user_id, :store_prop_id)
      @aupay_db = 
        result_period(@aupay_user,@results_date)
        .where.not(store_prop: {head_store: nil})
        .where(status: "審査通過").select(:valuation_new, :user_id, :store_prop_id,:date,:status,:result_point,:share)
      @aupay_def =  aupay_def(@aupay_uq,@results_date).select(:valuation_new, :date,:result_point,:status,:user_id, :store_prop_id)
      @aupay_inc = judge_inc(@aupay_user,@results_date).where(store_prop: {head_store: nil}).select(:valuation_new, :user_id, :store_prop_id,:date, :result_point, :status,:id,:deficiency_remarks)
      @aupay_dec = judge_dec(@aupay_user,@results_date).select(:id,:valuation_new, :user_id, :store_prop_id,:status,:date,:result_point,:status)
      @aupay_slmter = 
        Aupay.where(settlementer_id: @results.first.user_id).includes(:store_prop)
        .select(:settlementer_id, :valuation_settlement,:id,:status,:result_point,:store_prop_id,:date,:status_update_settlement,:status,:status_settlement)
      @aupay_ok = @aupay_slmter.where(status: "審査通過")
      @aupay_slmt = slmt_period(@aupay_slmter,@results_date) 
      @aupay_slmt_def = @aupay_ok.where(picture: @results_date_min..@results_date_max).where(settlement: nil).where("settlement_deadline > ?",Date.today)
      @aupay_pic_def = @aupay_ok.where(settlement: @results_date_min..@results_date_max).where(picture: nil).where("settlement_deadline > ?",Date.today)
      @aupay_slmt_target = slmt_dead_line(@aupay_user, @results_date).select(:valuation_settlement)
      @aupay_slmt_done = 
        @aupay_slmter.where(status_update_settlement: @month.beginning_of_month..@month.end_of_month)
        .where(status: "審査通過")
        .where(status_settlement: "完了")
      # paypay
      @paypay_user = 
        Paypay.where(user_id: @results.first.user_id).includes(:store_prop)
        .select(:valuation,:date,:result_point,:status,:store_prop_id,:id)
      @paypay_data = this_period(@paypay_user ,@results_date).select(:valuation)
      @paypay_result = result_period(@paypay_user ,@results_date)
      @paypay_done = 
        @paypay_user.where(result_point: @month.beginning_of_month..@month.end_of_month)
        .where(status: "60審査可決")
      # 楽天ペイ
      @rakuten_pay_user = 
        RakutenPay.includes(:store_prop).where(user_id: @results.first.user_id).select(:valuation,:store_prop_id)
      @rakuten_pay_uq =
        this_period(@rakuten_pay_user,@results_date).select(:valuation,:store_prop_id,:date,:id,:result_point,:status)
      @rakuten_pay_dec = 
        @rakuten_pay_uq.where.not(deficiency: nil)
        .where.not(share: @results_date.minimum(:date)..@results_date.maximum(:date)).select(:valuation,:store_prop_id)
      @rakuten_pay_def =  
        @rakuten_pay_uq.where(status: "自社不備")
        .or(@rakuten_pay_uq.where(status: "自社NG"))
        .select(:valuation,:store_prop_id,:date,:status,:result_point,:id)
      @rakuten_pay_inc = rakuten_inc(@rakuten_pay_user,@results_date).select(:valuation,:store_prop_id,:date,:status,:result_point,:id)
      @rakuten_pay_done_val = 
        @rakuten_pay_uq.sum(:valuation) - 
        @rakuten_pay_def.sum(:valuation) - 
        @rakuten_pay_dec.sum(:valuation) + 
        @rakuten_pay_inc.sum(:valuation)
      @rakuten_pay_done_len = 
        @rakuten_pay_uq.length - 
        @rakuten_pay_def.length - 
        @rakuten_pay_dec.length + 
        @rakuten_pay_inc.length
      # 少額短期保険
      @st_insurances_user = StInsurance.where(user_id: @results.first.user_id )
      @st_insurances_this_month = this_period(@st_insurances_user,@results)
      @st_insurances_def_this_month = this_period(@st_insurances_this_month,@results)
      @airpay_user = Airpay.where(user_id: @results.first.user_id)
      @airpay_result = 
        this_period(@airpay_user,@results)
        .where(status: "審査完了")
        .or(
          this_period(@airpay_user,@results)
          .where(status: "審査中")
        )
      @airpay_done = 
        @airpay_user.where(status: "審査完了")
        .where(result_point: @month.beginning_of_month..@month.end_of_month)
      # 楽天フェムト新規
      @rakuten_casas_user = RakutenCasa.where(user_id: @results.first.user_id)
      @rakuten_casas_this_month = this_period(@rakuten_casas_user, @results)
      @rakuten_casas_cancel = casa_cancel(@rakuten_casas_user, @results )
      @rakuten_casas_def_net = @rakuten_casas_this_month.where.not(deficiency_net: nil).where(deficiency_solution_net: nil)
      .or(@rakuten_casas_this_month.where.not(deficiency_net: nil).where(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date)))
      @rakuten_casas_def_anti = @rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil)
      .or(@rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date)))
      @rakuten_casas_not_this_month = not_period(@rakuten_casas_user, @results)
      @rakuten_casas_inc = inc_period(@rakuten_casas_not_this_month, @results)
      @rakuten_casas_inc_net = @rakuten_casas_not_this_month.where(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date))
      @rakuten_casas_dec_net = @rakuten_casas_not_this_month.where(deficiency_net: @results.minimum(:date)..@results.maximum(:date))
      @rakuten_casas_inc_anti = @rakuten_casas_not_this_month.where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date))
      @rakuten_casas_dec_anti = @rakuten_casas_not_this_month.where(deficiency_anti: @results.minimum(:date)..@results.maximum(:date))
      # 楽天フェムト設置
      @rakuten_casas_put = @rakuten_casas_user.where(put: @results.minimum(:date)..@results.maximum(:date))
      # 設置
      @rakuten_casas_put_self = @rakuten_casas_put.where(putter_id: @results.first.user_id).where(user_id: @results.first.user_id)
      # 他者設置
      @rakuten_casas_put_other = RakutenCasa.where.not(user_id: @results.first.user_id).where(putter_id: @results.first.user_id).where(put: @results.minimum(:date)..@results.maximum(:date))
      # 設置依頼
      @rakuten_casas_put_request = @rakuten_casas_put.where(user_id: @results.first.user_id).where.not(putter_id: @results.first.user_id)

      @comment = Comment.new
      session[:previous_url] = user_path(@user.id)
      @comments = Comment.select(:id,:status, :content,:store_prop_id,:request_show,:request)
    end

    def comment_new 
        @comment = Comment.new(comment_params)
        if @comment.save 
          flash[:notice] = "対応結果を登録しました。"
          redirect_to request.referer
        else  
          flash[:notice] = "登録できませんでした。"
          redirect_to session[:previous_url]
        end 
    end 

    def comment_update
      @comment = Comment.find(comment_params[:id])
      @comment.update(comment_params)
      flash[:notice] = "対応結果を更新しました。"
      redirect_to request.referer
    end  
  end 



  private 
  def user_params 
    params.require(:user).permit(
      :base,
      :base_sub,
      :position,
      :position_sub,
      :group,
      :team,
      :email,
      :password,
      :password_confirmation
    )
  end

  def comment_params 
    params.permit(
      :store_prop_id         ,
      :product            ,
      :content            ,
      :status             ,
      :ball               ,
      :request            ,
      :request_show       ,
      :response           ,
      :response_show      ,
      :done     
    )
  end 

  # dメル,aupayメソッド
    # 新規
      # 絞り込んだ期間のもの
      def this_period(product,date)
        return product.where(date: date.minimum(:date)..date.maximum(:date))
      end
      
      def dmer_def(product, date)
        return product.where(status: "自社不備")
          .or(product.where(status: "審査NG"))
          .or(product.where(status: "不備対応中"))
          .or(product.where(status: "申込取消"))
          .or(product.where(status: "申込取消（不備）"))
          .or(product.where(industry_status: "NG"))
          .or(product.where(industry_status: "×"))
          .or(product.where(industry_status: "要確認"))
          # .or(product.where(status: "審査OK")
          # .where.not(result_point: date.minimum(:date)..date.maximum(:date).end_of_month))
      end

      

      def judge_inc(product, date)
        return product.where.not(date: date.minimum(:date)..date.maximum(:date))
          .where(status: "審査通過")
          .where(result_point: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
          .or(product.where.not(date: date.minimum(:date)..date.maximum(:date))
          .where(status: "審査OK").where(result_point: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month))
      end

      def judge_dec(product, date)
        return product.where(date: date.minimum(:date)..date.maximum(:date))
          .where(status: "審査通過")
          .where.not(result_point: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
          .or(product.where(date: date.minimum(:date)..date.maximum(:date))
          .where(status: "審査OK")
          .where.not(result_point: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month))
      end



      def aupay_def(product, date)
        return product.where(status: "自社不備")
        .or(product.where(status: "不合格"))
        .or(product.where(status: "差し戻し"))
        .or(product.where(status: "解約"))
        .or(product.where(status: "報酬対象外"))
        .or(product.where(status: "重複対象外"))
        # .or(product.where(status: "審査通過")
        # .where.not(result_point: date.minimum(:date)..date.maximum(:date).end_of_month))
      end

      def not_period(product,date)
        return product.where.not(date: date.minimum(:date)..date.maximum(:date))
      end
      # 絞り込んだ期間ではなく、不備解消が絞り込んだ期間のもの
      def inc_period(product,date)
        return product.where.not(date: date.minimum(:date)..date.maximum(:date)).where(deficiency_solution: date.minimum(:date)..date.maximum(:date))
      end

      def share_period(product, date)
        return product.where(share: date.minimum(:date)..date.maximum(:date))
      end

    # 決済
    def slmt_this_period(product,date)
      return product
        .where("result_point < ?", date.maximum(:date).end_of_month)
        .where(status_update_settlement: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
        .where.not(status: "不備対応中")
        .where.not(status: "審査NG")
        .where.not(status: "申込取消")
        .where.not(status: "申込取消（不備）")
        .where.not(status: "不合格")
        .where.not(status: "報酬対象外")
        .where.not(status: "重複対象外")
        .where.not(status: "差し戻し")
        .where.not(status: "解約")
        .where(status_settlement: "完了")
        .or(
          product.where("status_update_settlement < ?", date.maximum(:date).beginning_of_month)
          .where.not(status: "不備対応中")
          .where.not(status: "審査NG")
          .where.not(status: "申込取消")
          .where.not(status: "申込取消（不備）")
          .where(status_settlement: "完了")
          .where.not(status: "不合格")
          .where.not(status: "報酬対象外")
          .where.not(status: "重複対象外")
          .where.not(status: "差し戻し")
          .where.not(status: "解約")
          .where(status_settlement: "完了")
          .where(result_point: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
        )
        .or(
          product.where(result_point: nil)
          .where(status_update_settlement: date.maximum(:date).beginning_of_month..date.maximum(:date).end_of_month)
          .where.not(status: "不備対応中")
          .where.not(status: "審査NG")
          .where.not(status: "申込取消")
          .where.not(status: "申込取消（不備）")
          .where(status_settlement: "完了")
          .where.not(status: "不合格")
          .where.not(status: "報酬対象外")
          .where.not(status: "重複対象外")
          .where.not(status: "差し戻し")
          .where.not(status: "解約")
          .where(status_settlement: "完了")
        )
    end

    def slmt_period(product, date)
      return product
      .where(picture: date.minimum(:date)..date.maximum(:date))
      .where.not(status: "不備対応中")
      .where.not(status: "審査NG")
      .where.not(status: "申込取消")
      .where.not(status: "申込取消（不備）")
      .where.not(status: "不合格")
      .where.not(status: "報酬対象外")
      .where.not(status: "重複対象外")
      .where.not(status: "差し戻し")
      .where.not(status: "解約")
      .where(status_settlement: "完了")
    end 
    
    def slmt_def(product,date)
      return product.where(status_update_settlement: date.minimum(:date)..date.maximum(:date))
        .where(status_settlement: "未決済")
    end
    def slmt_pic(product,date)
      return product.where(status_update_settlement: date.minimum(:date)..date.maximum(:date)).where(status_settlement: "写真不備")
    end

    def slmt_not_period(product,date)
      return product.where.not(status_update_settlement: date.minimum(:date)..date.maximum(:date))
    end
    def slmt_inc_period(product,date)
      return product.where(deficiency_solution_settlement: date.minimum(:date)..date.maximum(:date))
    end
    def slmt_dec_period(product,date)
      return product.where(deficiency_settlement: date.minimum(:date)..date.maximum(:date))
    end
    def slmt_def_period(product,date)
      return product.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(product.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: date.minimum(:date)..date.maximum(:date)))
    end

    def slmt_dead_line(product,date)
      return product.where(settlement_deadline: date.minimum(:date)..date.maximum(:date).since(3.month).end_of_month).where(status: "審査OK").where(settlement: nil)
      .or(product.where(settlement_deadline: date.minimum(:date)..date.maximum(:date).since(3.month).end_of_month).where(status: "審査OK").where(settlement: date.minimum(:date)..date.maximum(:date)))
      .or(product.where(settlement_deadline: date.minimum(:date)..date.maximum(:date).since(3.month).end_of_month).where(status: "審査通過").where(settlement: nil))
      .or(product.where(settlement_deadline: date.minimum(:date)..date.maximum(:date).since(3.month).end_of_month).where(status: "審査通過").where(settlement: date.minimum(:date)..date.maximum(:date)))
    end

    def slmt2nd_get(product,date)
      return product.where(settlement_second: date.minimum(:date)..date.maximum(:date))
    end 
    def slmt_second(product,date)
      return product.where(settlement_second: date.minimum(:date)..date.maximum(:date))
      .where(status: "審査OK")
      .where.not(industry_status: "×")
      .where.not(industry_status: "NG")
      .where(status_settlement: "完了")
    end 

    def slmt2nd_dead_line(product,date)
      return product.where(client: "ピアズ")
        .where(settlement_deadline: date.minimum(:date)
        .prev_month..date.maximum(:date).since(3.month).end_of_month)
        .where.not(industry_status: "×").where.not(industry_status: "NG").where(status: "審査OK")
        .where(settlement: Date.new(2021-12-01)..date.maximum(:date).prev_month.end_of_month)
        .where(settlement_second: date.minimum(:date)..date.maximum(:date))
        .or(product.where(client: "ピアズ")
        .where(settlement_deadline: date.minimum(:date).prev_month..date.maximum(:date).since(3.month).end_of_month)
        .where.not(industry_status: "×").where.not(industry_status: "NG").where(status: "審査OK")
        .where(settlement: Date.new(2021-12-01)..date.maximum(:date)
        .prev_month.end_of_month).where(settlement_second: nil))
        .or(product.where(client: "マックス即時（ｄ）")
        .where(status_settlement: "完了").where.not(industry_status: "×").where.not(industry_status: "NG").where(status: "審査OK")
        .where(settlement_second: nil))
        .or(product.where(client: "マックス即時（ｄ）")
        .where(status_settlement: "完了").where.not(industry_status: "×").where.not(industry_status: "NG").where(status: "審査OK")
        .where(settlement_second: date.minimum(:date)..date.maximum(:date)))
        .or(product.where(client: "ピアズ即時")
        .where(status_settlement: "完了").where.not(industry_status: "×").where.not(industry_status: "NG").where(status: "審査OK")
        .where(settlement_second: nil))
        .or(product.where(client: "ピアズ即時")
        .where(status_settlement: "完了").where.not(industry_status: "×").where.not(industry_status: "NG").where(status: "審査OK")
        .where(settlement_second: date.minimum(:date)..date.maximum(:date)))
    end

    def result_period(product, date)
      return product
        .where(result_point: date.minimum(:date).next_month.beginning_of_month..date.minimum(:date).next_month.end_of_month)
    end
  # dメル,aupayメソッド

  # 楽天フェムトメソッド
    def casa_cancel(product, date)
      return product.where(date: date.minimum(:date)..date.maximum(:date)).where(status: "キャンセル")
    end

    def rakuten_inc(product, date)
      return product
        .where.not(date: date.minimum(:date)..date.maximum(:date))
        .where(share: date.minimum(:date)..date.maximum(:date))
        .where.not(deficiency: nil)
    end 

end
