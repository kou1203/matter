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
    @calc_periods = CalcPeriod.where(sales_category: "評価売")
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    # calc_period_and_perは"@calc_periods"と"@month"の配置を先にするのが必須
    calc_period_and_per
    @shifts = Shift.includes(:user).all
    @user = User.find(params[:id])
    @shift = @shifts.where(user_id: @user.id)
    # 月間増減
    @before_airpay_bonus_date = Date.new(2022,10,1)
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
    @dmers_db = Dmer.includes(:store_prop).where.not(store_prop: {head_store: nil}).where(date: @month.all_month).where(user_id: @user.id)

    @aupays = Aupay.includes(:store_prop).where(date: @month.all_month).where(user_id: @user.id).where(store_prop: {head_store: nil})
    @aupays_inc = 
      Aupay.includes(:store_prop).where(result_point: @month.all_month).where(user_id: @user.id)
      .where(store_prop: {head_store: nil}).where.not(date: @month.all_month).where(status: "審査通過")
    @aupays_dec = 
      Aupay.includes(:store_prop).where.not(result_point: @month.all_month).where(user_id: @user.id)
      .where(store_prop: {head_store: nil}).where(date: @month.all_month).where(status: "審査通過")
      @aupays_db = Aupay.includes(:store_prop).where(date: @month.all_month).where.not(store_prop: {head_store: nil}).where(user_id: @user.id)
    @rakuten_pays = RakutenPay.includes(:store_prop).where(date: @month.all_month).where(user_id: @user.id)
    @rakuten_pays_inc = 
      RakutenPay.includes(:store_prop)
      .where.not(date: @month.all_month).where(user_id: @user.id)
      .where(share: @month.all_month).where.not(deficiency: nil)
    @rakuten_pays_dec = RakutenPay.includes(:store_prop).where(date: @month.all_month).where(user_id: @user.id)
    .where.not(share: @month.all_month).where.not(deficiency: nil)

    @airpays = Airpay.includes(:store_prop).where(date: @month.all_month).where(user_id: @user.id)
    @airpay_def_ng = @airpays.where(status: "審査NG")
    .or(
      @airpays.where(status: "代表者情報不備")
      )
    .or(
      @airpays.where(status: "店舗情報不備")
      )
    .or(
      @airpays.where(status: "口座情報不備")
      )
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
    @start_done = @month.beginning_of_month
    @end_done = @month.end_of_month
    @results = Result.includes(:user,:result_cash).where(user_id: @user.id).where(date: @start_date..@end_date).order(:date)
    # 拠点別resultデータ
    @results_chubu = 
      Result.includes(:user,:result_cash)
      .where(user: {base: "中部SS"})
      .where(user: {base_sub: "キャッシュレス"})
      .where(date: @start_date..@end_date).order(:date)
    @results_kanto = 
      Result.includes(:user, :result_cash)
      .where(user: {base: "関東SS"})
      .where(user: {base_sub: "キャッシュレス"})
      .where(date: @start_date..@end_date).order(:date)
    @results_kansai = 
      Result.includes(:user, :result_cash)
      .where(user: {base: "関西SS"})
      .where(user: {base_sub: "キャッシュレス"})
      .where(date: @start_date..@end_date).order(:date)
    # 拠点別新規消化シフト
    @shift_digestion_chubu = @results_chubu.where(shift: "キャッシュレス新規").length
    @shift_digestion_kansai = @results_kansai.where(shift: "キャッシュレス新規").length
    @shift_digestion_kanto = @results_kanto.where(shift: "キャッシュレス新規").length
    @results_date = @results
    @results_out = @results.includes(:result_cash) rescue "NaN"
    # 中部基準値
      @chubu_shift = 
        Shift.includes(:user).where(user: {base: "中部SS"})
        .where(start_time: @start_date..@end_date)
        .where(shift: "キャッシュレス新規").length
      @chubu_result = 
        Result.includes(:user, :result_cash).where(user: {base: "中部SS"})
        .where(date: @start_date..@end_date)
        .where(shift: "キャッシュレス新規")
      #  合計変数 
      @sum_total_visit_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:first_total_visit) + @chubu_result.where(shift: "キャッシュレス新規").sum(:latter_total_visit) 
      @sum_visit_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:first_visit) + @chubu_result.where(shift: "キャッシュレス新規").sum(:latter_visit) 
      @sum_interview_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:first_interview) + @chubu_result.where(shift: "キャッシュレス新規").sum(:latter_interview) 
      @sum_full_talk_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:first_full_talk) + @chubu_result.where(shift: "キャッシュレス新規").sum(:latter_full_talk) 
      @sum_get_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:first_get) + @chubu_result.where(shift: "キャッシュレス新規").sum(:latter_get)
     #  前半変数 
      @sum_total_visit_f_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:first_total_visit) 
      @sum_visit_f_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:first_visit) 
      @sum_interview_f_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:first_interview) 
      @sum_full_talk_f_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:first_full_talk) 
      @sum_get_f_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:first_get) 
     # 後半変数 
     @sum_total_visit_l_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:latter_total_visit) 
      @sum_visit_l_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:latter_visit) 
      @sum_interview_l_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:latter_interview) 
      @sum_full_talk_l_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:latter_full_talk) 
      @sum_get_l_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:latter_get) 
      # 店舗別合計変数 
       @cafe_visit_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:cafe_visit) 
       @cafe_get_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:cafe_get) 
       @other_food_visit_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:other_food_visit) 
       @other_food_get_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:other_food_get) 
       @car_visit_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:car_visit) 
       @car_get_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:car_get) 
       @other_retail_visit_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:other_retail_visit) 
       @other_retail_get_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:other_retail_get) 
       @hair_salon_visit_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:hair_salon_visit) 
       @hair_salon_get_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:hair_salon_get) 
       @manipulative_visit_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:manipulative_visit) 
       @manipulative_get_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:manipulative_get) 
       @other_service_visit_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:other_service_visit) 
       @other_service_get_sum_chubu = @chubu_result.where(shift: "キャッシュレス新規").sum(:other_service_get) 
      # 全店舗合計変数 
       @store_visit_sum_chubu = @cafe_visit_sum_chubu +  @other_food_visit_sum_chubu + @car_visit_sum_chubu + @other_retail_visit_sum_chubu + @hair_salon_visit_sum_chubu + @manipulative_visit_sum_chubu + @other_service_visit_sum_chubu 
       @store_get_sum_chubu = @cafe_get_sum_chubu +  @other_food_get_sum_chubu + @car_get_sum_chubu + @other_retail_get_sum_chubu + @hair_salon_get_sum_chubu + @manipulative_get_sum_chubu + @other_service_get_sum_chubu 
     # 時間別基準値合計
        @visit10_sum_chubu = @chubu_result.sum(:visit10)
        @visit10_ave_chubu = (@visit10_sum_chubu.to_f / @chubu_result.length).round(1)
        @get10_sum_chubu = @chubu_result.sum(:get10)
        @get10_ave_chubu = (@get10_sum_chubu.to_f / @chubu_result.length).round(1)

        @visit11_sum_chubu = @chubu_result.sum(:visit11)
        @visit11_ave_chubu = (@visit11_sum_chubu.to_f / @chubu_result.length).round(1)
        @get11_sum_chubu = @chubu_result.sum(:get11)
        @get11_ave_chubu = (@get11_sum_chubu.to_f / @chubu_result.length).round(1)

        @visit12_sum_chubu = @chubu_result.sum(:visit12)
        @visit12_ave_chubu = (@visit12_sum_chubu.to_f / @chubu_result.length).round(1)
        @get12_sum_chubu = @chubu_result.sum(:get12)
        @get12_ave_chubu = (@get12_sum_chubu.to_f / @chubu_result.length).round(1)

        @visit13_sum_chubu = @chubu_result.sum(:visit13)
        @visit13_ave_chubu = (@visit13_sum_chubu.to_f / @chubu_result.length).round(1)
        @get13_sum_chubu = @chubu_result.sum(:get13)
        @get13_ave_chubu = (@get13_sum_chubu.to_f / @chubu_result.length).round(1)

        @visit14_sum_chubu = @chubu_result.sum(:visit14)
        @visit14_ave_chubu = (@visit14_sum_chubu.to_f / @chubu_result.length).round(1)
        @get14_sum_chubu = @chubu_result.sum(:get14)
        @get14_ave_chubu = (@get14_sum_chubu.to_f / @chubu_result.length).round(1)

        @visit15_sum_chubu = @chubu_result.sum(:visit15)
        @visit15_ave_chubu = (@visit15_sum_chubu.to_f / @chubu_result.length).round(1)
        @get15_sum_chubu = @chubu_result.sum(:get15)
        @get15_ave_chubu = (@get15_sum_chubu.to_f / @chubu_result.length).round(1)

        @visit16_sum_chubu = @chubu_result.sum(:visit16)
        @visit16_ave_chubu = (@visit16_sum_chubu.to_f / @chubu_result.length).round(1)
        @get16_sum_chubu = @chubu_result.sum(:get16)
        @get16_ave_chubu = (@get16_sum_chubu.to_f / @chubu_result.length).round(1)

        @visit17_sum_chubu = @chubu_result.sum(:visit17)
        @visit17_ave_chubu = (@visit17_sum_chubu.to_f / @chubu_result.length).round(1)
        @get17_sum_chubu = @chubu_result.sum(:get17)
        @get17_ave_chubu = (@get17_sum_chubu.to_f / @chubu_result.length).round(1)

        @visit18_sum_chubu = @chubu_result.sum(:visit18)
        @visit18_ave_chubu = (@visit18_sum_chubu.to_f / @chubu_result.length).round(1)
        @get18_sum_chubu = @chubu_result.sum(:get18)
        @get18_ave_chubu = (@get18_sum_chubu.to_f / @chubu_result.length).round(1)

        @visit19_sum_chubu = @chubu_result.sum(:visit19)
        @visit19_ave_chubu = (@visit19_sum_chubu.to_f / @chubu_result.length).round(1)
        @get19_sum_chubu = @chubu_result.sum(:get19)
        @get19_ave_chubu = (@get19_sum_chubu.to_f / @chubu_result.length).round(1)

        @time_visit_sum_chubu = [@visit10_sum_chubu,@visit11_sum_chubu,@visit12_sum_chubu,@visit13_sum_chubu,@visit14_sum_chubu,@visit15_sum_chubu,@visit16_sum_chubu,@visit17_sum_chubu,@visit18_sum_chubu,@visit19_sum_chubu]
        @time_visit_ave_chubu = [@visit10_ave_chubu,@visit11_ave_chubu,@visit12_ave_chubu,@visit13_ave_chubu,@visit14_ave_chubu,@visit15_ave_chubu,@visit16_ave_chubu,@visit17_ave_chubu,@visit18_ave_chubu,@visit19_ave_chubu]
        @time_get_sum_chubu = [@get10_sum_chubu,@get11_sum_chubu,@get12_sum_chubu,@get13_sum_chubu,@get14_sum_chubu,@get15_sum_chubu,@get16_sum_chubu,@get17_sum_chubu,@get18_sum_chubu,@get19_sum_chubu]
        @time_get_ave_chubu = [@get10_ave_chubu,@get11_ave_chubu,@get12_ave_chubu,@get13_ave_chubu,@get14_ave_chubu,@get15_ave_chubu,@get16_ave_chubu,@get17_ave_chubu,@get18_ave_chubu,@get19_ave_chubu]
    # /中部基準値
    # 関西基準値
      @kansai_shift = 
        Shift.includes(:user).where(user: {base: "関西SS"})
        .where(start_time: @start_date..@end_date)
        .where(shift: "キャッシュレス新規").length
      @kansai_result = 
        Result.includes(:user, :result_cash).where(user: {base: "関西SS"})
        .where(date: @start_date..@end_date)
        .where(shift: "キャッシュレス新規")
      #  合計変数 
      @sum_total_visit_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:first_total_visit) + @kansai_result.where(shift: "キャッシュレス新規").sum(:latter_total_visit) 
      @sum_visit_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:first_visit) + @kansai_result.where(shift: "キャッシュレス新規").sum(:latter_visit) 
      @sum_interview_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:first_interview) + @kansai_result.where(shift: "キャッシュレス新規").sum(:latter_interview) 
      @sum_full_talk_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:first_full_talk) + @kansai_result.where(shift: "キャッシュレス新規").sum(:latter_full_talk) 
      @sum_get_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:first_get) + @kansai_result.where(shift: "キャッシュレス新規").sum(:latter_get) 
     #  前半変数 
      @sum_total_visit_f_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:first_total_visit) 
      @sum_visit_f_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:first_visit) 
      @sum_interview_f_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:first_interview) 
      @sum_full_talk_f_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:first_full_talk) 
      @sum_get_f_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:first_get) 
     # 後半変数 
      @sum_total_visit_l_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:latter_total_visit) 
      @sum_visit_l_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:latter_visit) 
      @sum_interview_l_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:latter_interview) 
      @sum_full_talk_l_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:latter_full_talk) 
      @sum_get_l_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:latter_get) 
      # 店舗別合計変数 
       @cafe_visit_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:cafe_visit) 
       @cafe_get_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:cafe_get) 
       @other_food_visit_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:other_food_visit) 
       @other_food_get_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:other_food_get) 
       @car_visit_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:car_visit) 
       @car_get_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:car_get) 
       @other_retail_visit_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:other_retail_visit) 
       @other_retail_get_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:other_retail_get) 
       @hair_salon_visit_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:hair_salon_visit) 
       @hair_salon_get_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:hair_salon_get) 
       @manipulative_visit_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:manipulative_visit) 
       @manipulative_get_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:manipulative_get) 
       @other_service_visit_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:other_service_visit) 
       @other_service_get_sum_kansai = @kansai_result.where(shift: "キャッシュレス新規").sum(:other_service_get) 
      # 全店舗合計変数 
       @store_visit_sum_kansai = @cafe_visit_sum_kansai +  @other_food_visit_sum_kansai + @car_visit_sum_kansai + @other_retail_visit_sum_kansai + @hair_salon_visit_sum_kansai + @manipulative_visit_sum_kansai + @other_service_visit_sum_kansai 
       @store_get_sum_kansai = @cafe_get_sum_kansai +  @other_food_get_sum_kansai + @car_get_sum_kansai + @other_retail_get_sum_kansai + @hair_salon_get_sum_kansai + @manipulative_get_sum_kansai + @other_service_get_sum_kansai 
     # 時間別基準値合計
      @visit10_sum_kansai = @kansai_result.sum(:visit10)
      @visit10_ave_kansai = (@visit10_sum_kansai.to_f / @kansai_result.length).round(1)
      @get10_sum_kansai = @kansai_result.sum(:get10)
      @get10_ave_kansai = (@get10_sum_kansai.to_f / @kansai_result.length).round(1)

      @visit11_sum_kansai = @kansai_result.sum(:visit11)
      @visit11_ave_kansai = (@visit11_sum_kansai.to_f / @kansai_result.length).round(1)
      @get11_sum_kansai = @kansai_result.sum(:get11)
      @get11_ave_kansai = (@get11_sum_kansai.to_f / @kansai_result.length).round(1)

      @visit12_sum_kansai = @kansai_result.sum(:visit12)
      @visit12_ave_kansai = (@visit12_sum_kansai.to_f / @kansai_result.length).round(1)
      @get12_sum_kansai = @kansai_result.sum(:get12)
      @get12_ave_kansai = (@get12_sum_kansai.to_f / @kansai_result.length).round(1)

      @visit13_sum_kansai = @kansai_result.sum(:visit13)
      @visit13_ave_kansai = (@visit13_sum_kansai.to_f / @kansai_result.length).round(1)
      @get13_sum_kansai = @kansai_result.sum(:get13)
      @get13_ave_kansai = (@get13_sum_kansai.to_f / @kansai_result.length).round(1)

      @visit14_sum_kansai = @kansai_result.sum(:visit14)
      @visit14_ave_kansai = (@visit14_sum_kansai.to_f / @kansai_result.length).round(1)
      @get14_sum_kansai = @kansai_result.sum(:get14)
      @get14_ave_kansai = (@get14_sum_kansai.to_f / @kansai_result.length).round(1)

      @visit15_sum_kansai = @kansai_result.sum(:visit15)
      @visit15_ave_kansai = (@visit15_sum_kansai.to_f / @kansai_result.length).round(1)
      @get15_sum_kansai = @kansai_result.sum(:get15)
      @get15_ave_kansai = (@get15_sum_kansai.to_f / @kansai_result.length).round(1)

      @visit16_sum_kansai = @kansai_result.sum(:visit16)
      @visit16_ave_kansai = (@visit16_sum_kansai.to_f / @kansai_result.length).round(1)
      @get16_sum_kansai = @kansai_result.sum(:get16)
      @get16_ave_kansai = (@get16_sum_kansai.to_f / @kansai_result.length).round(1)

      @visit17_sum_kansai = @kansai_result.sum(:visit17)
      @visit17_ave_kansai = (@visit17_sum_kansai.to_f / @kansai_result.length).round(1)
      @get17_sum_kansai = @kansai_result.sum(:get17)
      @get17_ave_kansai = (@get17_sum_kansai.to_f / @kansai_result.length).round(1)

      @visit18_sum_kansai = @kansai_result.sum(:visit18)
      @visit18_ave_kansai = (@visit18_sum_kansai.to_f / @kansai_result.length).round(1)
      @get18_sum_kansai = @kansai_result.sum(:get18)
      @get18_ave_kansai = (@get18_sum_kansai.to_f / @kansai_result.length).round(1)

      @visit19_sum_kansai = @kansai_result.sum(:visit19)
      @visit19_ave_kansai = (@visit19_sum_kansai.to_f / @kansai_result.length).round(1)
      @get19_sum_kansai = @kansai_result.sum(:get19)
      @get19_ave_kansai = (@get19_sum_kansai.to_f / @kansai_result.length).round(1)

      @time_visit_sum_kansai = [@visit10_sum_kansai,@visit11_sum_kansai,@visit12_sum_kansai,@visit13_sum_kansai,@visit14_sum_kansai,@visit15_sum_kansai,@visit16_sum_kansai,@visit17_sum_kansai,@visit18_sum_kansai,@visit19_sum_kansai]
      @time_visit_ave_kansai = [@visit10_ave_kansai,@visit11_ave_kansai,@visit12_ave_kansai,@visit13_ave_kansai,@visit14_ave_kansai,@visit15_ave_kansai,@visit16_ave_kansai,@visit17_ave_kansai,@visit18_ave_kansai,@visit19_ave_kansai]
      @time_get_sum_kansai = [@get10_sum_kansai,@get11_sum_kansai,@get12_sum_kansai,@get13_sum_kansai,@get14_sum_kansai,@get15_sum_kansai,@get16_sum_kansai,@get17_sum_kansai,@get18_sum_kansai,@get19_sum_kansai]
      @time_get_ave_kansai = [@get10_ave_kansai,@get11_ave_kansai,@get12_ave_kansai,@get13_ave_kansai,@get14_ave_kansai,@get15_ave_kansai,@get16_ave_kansai,@get17_ave_kansai,@get18_ave_kansai,@get19_ave_kansai]
    # /関西基準値

    # 関東基準値
      @kanto_shift = 
        Shift.includes(:user).where(user: {base: "関東SS"})
        .where(start_time: @start_date..@end_date)
        .where(shift: "キャッシュレス新規").length
      @kanto_result = 
        Result.includes(:user,:result_cash).where(user: {base: "関東SS"})
        .where(date: @start_date..@end_date)
        .where(shift: "キャッシュレス新規")
      #  合計変数 
      @sum_total_visit_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:first_total_visit) + @kanto_result.where(shift: "キャッシュレス新規").sum(:latter_total_visit)
      @sum_visit_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:first_visit) + @kanto_result.where(shift: "キャッシュレス新規").sum(:latter_visit)
      @sum_interview_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:first_interview) + @kanto_result.where(shift: "キャッシュレス新規").sum(:latter_interview) 
      @sum_full_talk_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:first_full_talk) + @kanto_result.where(shift: "キャッシュレス新規").sum(:latter_full_talk) 
      @sum_get_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:first_get) + @kanto_result.where(shift: "キャッシュレス新規").sum(:latter_get) 
     #  前半変数 
      @sum_total_visit_f_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:first_total_visit) 
      @sum_visit_f_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:first_visit) 
      @sum_interview_f_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:first_interview) 
      @sum_full_talk_f_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:first_full_talk) 
      @sum_get_f_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:first_get) 
     # 後半変数 
      @sum_total_visit_l_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:latter_total_visit) 
      @sum_visit_l_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:latter_visit) 
      @sum_interview_l_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:latter_interview) 
      @sum_full_talk_l_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:latter_full_talk) 
      @sum_get_l_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:latter_get) 
      # 店舗別合計変数 
       @cafe_visit_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:cafe_visit) 
       @cafe_get_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:cafe_get) 
       @other_food_visit_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:other_food_visit) 
       @other_food_get_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:other_food_get) 
       @car_visit_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:car_visit) 
       @car_get_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:car_get) 
       @other_retail_visit_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:other_retail_visit) 
       @other_retail_get_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:other_retail_get) 
       @hair_salon_visit_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:hair_salon_visit) 
       @hair_salon_get_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:hair_salon_get) 
       @manipulative_visit_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:manipulative_visit) 
       @manipulative_get_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:manipulative_get) 
       @other_service_visit_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:other_service_visit) 
       @other_service_get_sum_kanto = @kanto_result.where(shift: "キャッシュレス新規").sum(:other_service_get) 
      # 全店舗合計変数 
       @store_visit_sum_kanto = @cafe_visit_sum_kanto +  @other_food_visit_sum_kanto + @car_visit_sum_kanto + @other_retail_visit_sum_kanto + @hair_salon_visit_sum_kanto + @manipulative_visit_sum_kanto + @other_service_visit_sum_kanto 
       @store_get_sum_kanto = @cafe_get_sum_kanto +  @other_food_get_sum_kanto + @car_get_sum_kanto + @other_retail_get_sum_kanto + @hair_salon_get_sum_kanto + @manipulative_get_sum_kanto + @other_service_get_sum_kanto 
     # 時間別基準値合計
     @visit10_sum_kanto = @kanto_result.sum(:visit10)
     @visit10_ave_kanto = (@visit10_sum_kanto.to_f / @kanto_result.length).round(1)
     @get10_sum_kanto = @kanto_result.sum(:get10)
     @get10_ave_kanto = (@get10_sum_kanto.to_f / @kanto_result.length).round(1)

     @visit11_sum_kanto = @kanto_result.sum(:visit11)
     @visit11_ave_kanto = (@visit11_sum_kanto.to_f / @kanto_result.length).round(1)
     @get11_sum_kanto = @kanto_result.sum(:get11)
     @get11_ave_kanto = (@get11_sum_kanto.to_f / @kanto_result.length).round(1)

     @visit12_sum_kanto = @kanto_result.sum(:visit12)
     @visit12_ave_kanto = (@visit12_sum_kanto.to_f / @kanto_result.length).round(1)
     @get12_sum_kanto = @kanto_result.sum(:get12)
     @get12_ave_kanto = (@get12_sum_kanto.to_f / @kanto_result.length).round(1)

     @visit13_sum_kanto = @kanto_result.sum(:visit13)
     @visit13_ave_kanto = (@visit13_sum_kanto.to_f / @kanto_result.length).round(1)
     @get13_sum_kanto = @kanto_result.sum(:get13)
     @get13_ave_kanto = (@get13_sum_kanto.to_f / @kanto_result.length).round(1)

     @visit14_sum_kanto = @kanto_result.sum(:visit14)
     @visit14_ave_kanto = (@visit14_sum_kanto.to_f / @kanto_result.length).round(1)
     @get14_sum_kanto = @kanto_result.sum(:get14)
     @get14_ave_kanto = (@get14_sum_kanto.to_f / @kanto_result.length).round(1)

     @visit15_sum_kanto = @kanto_result.sum(:visit15)
     @visit15_ave_kanto = (@visit15_sum_kanto.to_f / @kanto_result.length).round(1)
     @get15_sum_kanto = @kanto_result.sum(:get15)
     @get15_ave_kanto = (@get15_sum_kanto.to_f / @kanto_result.length).round(1)

     @visit16_sum_kanto = @kanto_result.sum(:visit16)
     @visit16_ave_kanto = (@visit16_sum_kanto.to_f / @kanto_result.length).round(1)
     @get16_sum_kanto = @kanto_result.sum(:get16)
     @get16_ave_kanto = (@get16_sum_kanto.to_f / @kanto_result.length).round(1)

     @visit17_sum_kanto = @kanto_result.sum(:visit17)
     @visit17_ave_kanto = (@visit17_sum_kanto.to_f / @kanto_result.length).round(1)
     @get17_sum_kanto = @kanto_result.sum(:get17)
     @get17_ave_kanto = (@get17_sum_kanto.to_f / @kanto_result.length).round(1)

     @visit18_sum_kanto = @kanto_result.sum(:visit18)
     @visit18_ave_kanto = (@visit18_sum_kanto.to_f / @kanto_result.length).round(1)
     @get18_sum_kanto = @kanto_result.sum(:get18)
     @get18_ave_kanto = (@get18_sum_kanto.to_f / @kanto_result.length).round(1)

     @visit19_sum_kanto = @kanto_result.sum(:visit19)
     @visit19_ave_kanto = (@visit19_sum_kanto.to_f / @kanto_result.length).round(1)
     @get19_sum_kanto = @kanto_result.sum(:get19)
     @get19_ave_kanto = (@get19_sum_kanto.to_f / @kanto_result.length).round(1)

     @time_visit_sum_kanto = [@visit10_sum_kanto,@visit11_sum_kanto,@visit12_sum_kanto,@visit13_sum_kanto,@visit14_sum_kanto,@visit15_sum_kanto,@visit16_sum_kanto,@visit17_sum_kanto,@visit18_sum_kanto,@visit19_sum_kanto]
     @time_visit_ave_kanto = [@visit10_ave_kanto,@visit11_ave_kanto,@visit12_ave_kanto,@visit13_ave_kanto,@visit14_ave_kanto,@visit15_ave_kanto,@visit16_ave_kanto,@visit17_ave_kanto,@visit18_ave_kanto,@visit19_ave_kanto]
     @time_get_sum_kanto = [@get10_sum_kanto,@get11_sum_kanto,@get12_sum_kanto,@get13_sum_kanto,@get14_sum_kanto,@get15_sum_kanto,@get16_sum_kanto,@get17_sum_kanto,@get18_sum_kanto,@get19_sum_kanto]
     @time_get_ave_kanto = [@get10_ave_kanto,@get11_ave_kanto,@get12_ave_kanto,@get13_ave_kanto,@get14_ave_kanto,@get15_ave_kanto,@get16_ave_kanto,@get17_ave_kanto,@get18_ave_kanto,@get19_ave_kanto]
    # 関東基準値
    # 予定シフト変数 
      @result_shift = 
        @shift.where(start_time: @start_date..@end_date) rescue nil
      if @result_shift.blank?
      else
      @result_shift_min = @result_shift.minimum(:start_time)
      @result_shift_max = @result_shift.maximum(:start_time) 

      @new_shift = @result_shift.where(shift: "キャッシュレス新規").length 
      @new_shift26_10 = @result_shift.where(shift: "キャッシュレス新規").where(start_time: @result_shift_min..@result_shift_min.next_month.beginning_of_month.since(9.days)).length
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
       @sum_total_visit = @results.where(shift: "キャッシュレス新規").sum(:first_total_visit) + @results.where(shift: "キャッシュレス新規").sum(:latter_total_visit) 
       @sum_visit = @results.where(shift: "キャッシュレス新規").sum(:first_visit) + @results.where(shift: "キャッシュレス新規").sum(:latter_visit) 
       @sum_interview = @results.where(shift: "キャッシュレス新規").sum(:first_interview) + @results.where(shift: "キャッシュレス新規").sum(:latter_interview) 
       @sum_full_talk = @results.where(shift: "キャッシュレス新規").sum(:first_full_talk) + @results.where(shift: "キャッシュレス新規").sum(:latter_full_talk) 
       @sum_get = @results.where(shift: "キャッシュレス新規").sum(:first_get) + @results.where(shift: "キャッシュレス新規").sum(:latter_get)
      #  前半変数 
       @sum_total_visit_f = @results.where(shift: "キャッシュレス新規").sum(:first_total_visit) 
       @sum_visit_f = @results.where(shift: "キャッシュレス新規").sum(:first_visit) 
       @sum_interview_f = @results.where(shift: "キャッシュレス新規").sum(:first_interview) 
       @sum_full_talk_f = @results.where(shift: "キャッシュレス新規").sum(:first_full_talk) 
       @sum_get_f = @results.where(shift: "キャッシュレス新規").sum(:first_get) 
      # 後半変数 
      @sum_total_visit_l = @results.where(shift: "キャッシュレス新規").sum(:latter_total_visit) 
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
        @visit10_ave = (@visit10_sum.to_f / @digestion_new).round(1)
        @get10_sum = @results.sum(:get10)
        @get10_ave = (@get10_sum.to_f / @digestion_new).round(1)

        @visit11_sum = @results.sum(:visit11)
        @visit11_ave = (@visit11_sum.to_f / @digestion_new).round(1)
        @get11_sum = @results.sum(:get11)
        @get11_ave = (@get11_sum.to_f / @digestion_new).round(1)

        @visit12_sum = @results.sum(:visit12)
        @visit12_ave = (@visit12_sum.to_f / @digestion_new).round(1)
        @get12_sum = @results.sum(:get12)
        @get12_ave = (@get12_sum.to_f / @digestion_new).round(1)

        @visit13_sum = @results.sum(:visit13)
        @visit13_ave = (@visit13_sum.to_f / @digestion_new).round(1)
        @get13_sum = @results.sum(:get13)
        @get13_ave = (@get13_sum.to_f / @digestion_new).round(1)

        @visit14_sum = @results.sum(:visit14)
        @visit14_ave = (@visit14_sum.to_f / @digestion_new).round(1)
        @get14_sum = @results.sum(:get14)
        @get14_ave = (@get14_sum.to_f / @digestion_new).round(1)

        @visit15_sum = @results.sum(:visit15)
        @visit15_ave = (@visit15_sum.to_f / @digestion_new).round(1)
        @get15_sum = @results.sum(:get15)
        @get15_ave = (@get15_sum.to_f / @digestion_new).round(1)

        @visit16_sum = @results.sum(:visit16)
        @visit16_ave = (@visit16_sum.to_f / @digestion_new).round(1)
        @get16_sum = @results.sum(:get16)
        @get16_ave = (@get16_sum.to_f / @digestion_new).round(1)

        @visit17_sum = @results.sum(:visit17)
        @visit17_ave = (@visit17_sum.to_f / @digestion_new).round(1)
        @get17_sum = @results.sum(:get17)
        @get17_ave = (@get17_sum.to_f / @digestion_new).round(1)

        @visit18_sum = @results.sum(:visit18)
        @visit18_ave = (@visit18_sum.to_f / @digestion_new).round(1)
        @get18_sum = @results.sum(:get18)
        @get18_ave = (@get18_sum.to_f / @digestion_new).round(1)

        @visit19_sum = @results.sum(:visit19)
        @visit19_ave = (@visit19_sum.to_f / @digestion_new).round(1)
        @get19_sum = @results.sum(:get19)
        @get19_ave = (@get19_sum.to_f / @digestion_new).round(1)

        @time_visit_sum = [@visit10_sum,@visit11_sum,@visit12_sum,@visit13_sum,@visit14_sum,@visit15_sum,@visit16_sum,@visit17_sum,@visit18_sum,@visit19_sum]
        @time_visit_ave = [@visit10_ave,@visit11_ave,@visit12_ave,@visit13_ave,@visit14_ave,@visit15_ave,@visit16_ave,@visit17_ave,@visit18_ave,@visit19_ave]
        @time_get_sum = [@get10_sum,@get11_sum,@get12_sum,@get13_sum,@get14_sum,@get15_sum,@get16_sum,@get17_sum,@get18_sum,@get19_sum]
        @time_get_ave = [@get10_ave,@get11_ave,@get12_ave,@get13_ave,@get14_ave,@get15_ave,@get16_ave,@get17_ave,@get18_ave,@get19_ave]
    if @results.where(shift: "キャッシュレス新規").present?
      # 週毎の期間
      days = ["日", "月", "火", "水", "木", "金", "土"]
       if days[@start_date.wday] == "日" 
         week1 = (@start_date.since(1.days)) 
       elsif days[@start_date.wday] == "土" 
         week1 = (@start_date.ago(5.days))
       elsif days[@start_date.wday] == "金" 
         week1 = (@start_date.ago(4.days))
       elsif days[@start_date.wday] == "木" 
         week1 = (@start_date.ago(3.days)) 
       elsif days[@start_date.wday] == "水" 
         week1 = (@start_date.ago(2.days)) 
       elsif days[@start_date.wday] == "火" 
         week1 = (@start_date.ago(1.days)) 
       else 
        week1 = @start_date
       end
        @results_week1 = Result.where(user_id: @user.id).where(date: week1..(week1.since(6.days)))
        @results_week2 = Result.where(user_id: @user.id).where(date: (week1.since(7.days))..(week1.since(13.days)))
        @results_week3 = Result.where(user_id: @user.id).where(date: (week1.since(14.days))..(week1.since(20.days)))
        @results_week4 = Result.where(user_id: @user.id).where(date: (week1.since(21.days))..(week1.since(27.days)))
        @results_week5 = Result.where(user_id: @user.id).where(date: (week1.since(28.days))..(week1.since(34.days)))

      #  dメル
       @dmer_user = Dmer.includes(:store_prop).where(user_id: @results.first.user_id )
        @dmer_uq = 
          @dmer_user.where(date: @start_date..@end_date)
          .where(store_prop: {head_store: nil})
        @dmer_db_data = 
        @dmer_user.where(share: @start_date..@end_date)
        .where.not(store_prop: {head_store: nil})
        .where.not(industry_status: "×")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "要確認")
        .where(status: "審査OK")

        @dmer_def = 
          @dmer_uq.where(status: "自社不備")
          .or(@dmer_uq.where(status: "審査NG"))
          .or(@dmer_uq.where(status: "不備対応中"))
          .or(@dmer_uq.where(status: "申込取消"))
          .or(@dmer_uq.where(status: "申込取消（不備）"))
          .or(@dmer_uq.where(status: "社内確認中"))
          .or(@dmer_uq.where(industry_status: "NG"))
          .or(@dmer_uq.where(industry_status: "×"))
          .or(@dmer_uq.where(industry_status: "要確認"))
        @dmer_inc = 
          @dmer_user.where.not(date: @dmer1_start_date..@dmer1_end_date)
          .where(result_point: @dmer1_start_date..@dmer1_end_date)
          .where(store_prop: {head_store: nil})
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status: "審査OK")
        @dmer_dec = 
        judge_dec(@dmer_user,@results_date)
        .where.not(industry_status: "NG").where.not(industry_status: "×")
        
        @dmer_len = 
          @dmer_uq.length -
          @dmer_def.length +
          @dmer_db_data.length
          if (@dmer_len == 0) || (@digestion_new == 0)
            @dmer_len_ave = 0
          else  
            @dmer_len_ave = (@dmer_len.to_f / @digestion_new).round(1)
          end
        # dメル第一成果, 期間月初〜月末
        @dmer_done = 
          @dmer_user.where(result_point: @dmer1_start_date..@dmer1_end_date)
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status: "審査OK")
        # 決済
        @dmer_slmter = 
          Dmer.where(settlementer_id: @results.first.user_id)
        @dmer_slmt = 
        slmt_period(@dmer_slmter, @results_date)
        .where.not(industry_status: "×")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "要確認")
        @dmer_ok =
          @dmer_slmter.where(status: "審査OK")
          .where.not(industry_status: "×")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "要確認")
          .or(
            @dmer_slmter.where(industry_status: nil)
          )
        @dmer_slmt_def = @dmer_ok.where(picture: @start_date..@end_date).where(settlement: nil).where("settlement_deadline >= ?",Date.today)
        @dmer_pic_def = @dmer_ok.where(settlement: @start_date..@end_date).where(picture: nil).where("settlement_deadline >= ?",Date.today)

        @dmer_slmt_done = 
          @dmer_slmter.where(status_update_settlement: @month.beginning_of_month..@month.end_of_month)
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status: "審査OK")
          .where(status_settlement: "完了")
        @dmer_pic_def = @dmer_slmt.where(picture: nil)
        @dmer_slmt2nd_get = 
          slmt2nd_get(@dmer_slmter,@results_date)
        # dメル第三成果 = 審査完了 + (決済ステータス == 完了) 2回目決済が月内に完了 or
        # 2回目決済過去に完了 + 決済完了日が期間内
        @dmer_slmt2nd = 
          slmt_second(@dmer_slmter,@results_date)
          @dmer_slmt2nd_done = 
          @dmer_slmter.where(settlement_second: @month.beginning_of_month..@month.end_of_month)
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status: "審査OK")
          .where(status_settlement: "完了")
          .where("? >= status_update_settlement", @month.end_of_month)
          .or(
            @dmer_slmter.where("? >= settlement_second", @month.end_of_month)
            .where.not(industry_status: "NG")
            .where.not(industry_status: "×")
            .where.not(industry_status: "要確認")
            .where(status: "審査OK")
            .where(status_settlement: "完了")
            .where(status_update_settlement: @month.beginning_of_month..@month.end_of_month)
          )
        # 決済対象 
        @dmers_slmt_target = 
          slmt_dead_line(@dmer_user,@results_date)
          .where.not(industry_status: "NG").where.not(industry_status: "×").where.not(industry_status: "要確認")
          .or(slmt_dead_line(@dmer_slmter, @results_date)
          .where(industry_status: nil))
      # auPay
      @other_products = OtherProduct.where(user_id: @user.id).where(date: @month.beginning_of_month..@month.end_of_month)
      @aupay_pic = @other_products.where(product_name: "auPay写真")
      @dmer_pic = @other_products.where(product_name: "dメルステッカー")
      @other_products_val = @other_products.sum(:valuation)
      @dmer_pic_len = @dmer_pic.sum(:product_len)
      @dmer_pic_val = @dmer_pic.sum(:valuation)
      @aupay_pic_len = @aupay_pic.sum(:product_len)
      @aupay_pic_val = @aupay_pic.sum(:valuation)
      @aupay_user = 
        Aupay.includes(:store_prop).where(user_id: @results.first.user_id)
      @aupay_uq = 
        @aupay_user.where(date: @start_date..@end_date)
        .where(store_prop: {head_store: nil})
      @aupay_db = 
        @aupay_user.where(result_point: @start_date..@end_date)
        .where.not(store_prop: {head_store: nil})
        .where(status: "審査通過")
      @aupay_def =  
        @aupay_uq.where(status: "自社不備")
        .or(@aupay_uq.where(status: "不合格"))
        .or(@aupay_uq.where(status: "差し戻し"))
        .or(@aupay_uq.where(status: "解約"))
        .or(@aupay_uq.where(status: "報酬対象外"))
        .or(@aupay_uq.where(status: "重複対象外"))
      @aupay_inc = 
        @aupay_user.where.not(date: @start_date..@end_date)
        .where(result_point: @start_date..@end_date)
        .where(status: "審査通過")
        .where(store_prop: {head_store: nil})
      @aupay_dec = judge_dec(@aupay_user,@results_date)
      @aupay_len = 
        @aupay_uq.length - @aupay_def.length + 
        @aupay_db.length
      if (@aupay_len == 0) || (@digestion_new == 0)
        @aupay_len_ave = 0
      else
        @aupay_len_ave = (@aupay_len.to_f / @digestion_new).round(1)
      end
      @aupay_slmter = 
        Aupay.where(settlementer_id: @results.first.user_id).includes(:store_prop)
      @aupay_ok = @aupay_slmter.where(status: "審査通過")
      @aupay_slmt = slmt_period(@aupay_slmter,@results_date) 
      @aupay_slmt_def = @aupay_ok.where(picture: @start_date..@end_date).where(settlement: nil).where("settlement_deadline > ?",Date.today)
      @aupay_pic_def = @aupay_ok.where(settlement: @start_date..@end_date).where(picture: nil).where("settlement_deadline > ?",Date.today)
      @aupay_slmt_target = slmt_dead_line(@aupay_user, @results_date)
      @aupay_slmt_done = 
        @aupay_slmter.where(status_update_settlement: @month.beginning_of_month..@month.end_of_month)
        .where(status: "審査通過")
        .where(status_settlement: "完了")
      # paypay
      @paypay_user = 
        Paypay.where(user_id: @results.first.user_id).includes(:store_prop)
      @paypay_data = @paypay_user.where(date: @start_date..@end_date)
      if (@paypay_data.length == 0) || (@digestion_new == 0)
        @paypay_len_ave = 0
      else  
        @paypay_len_ave = (@paypay_data.length.to_f / @digestion_new).round(1)
      end
      @paypay_done = 
        @paypay_user.where(result_point: @paypay1_start_date..@paypay1_end_date)
        .where(status: "60審査可決")
      # 楽天ペイ
      @rakuten_pay_user = 
        RakutenPay.includes(:store_prop).where(user_id: @results.first.user_id)
      @rakuten_pay_uq =
        @rakuten_pay_user.where(date: @start_date..@end_date)
      @rakuten_pay_dec = 
        @rakuten_pay_uq.where.not(deficiency: nil)
        .where.not(share: @start_date..@end_date)
      @rakuten_pay_def =  
        @rakuten_pay_uq.where(status: "自社不備")
        .or(@rakuten_pay_uq.where(status: "自社NG"))
        .or(
          @rakuten_pay_uq.where(deficiency: @start_date..@end_date)
          .where.not(deficiency_solution: @start_date..@end_date)
        )
      @rakuten_pay_inc = 
        @rakuten_pay_user.where.not(date: @start_date..@end_date)
        .where(share: @start_date..@end_date)
        .where.not(deficiency: nil)
        
      @rakuten_pay_done_val = 
        @rakuten_pay_uq.sum(:valuation) - 
        @rakuten_pay_def.sum(:valuation) + 
        @rakuten_pay_inc.sum(:valuation)
      @rakuten_pay_done_len = 
        @rakuten_pay_uq.length - 
        @rakuten_pay_def.length +
        @rakuten_pay_inc.length
 
        if (@rakuten_pay_done_len == 0) || (@digestion_new == 0)
          @rakuten_pay_len_ave = 0
        else  
          @rakuten_pay_len_ave = (@rakuten_pay_done_len.to_f / @digestion_new).round(1)
        end
      @airpay_user = Airpay.includes(:store_prop).where(user_id: @results.first.user_id)
      @airpay_period = @airpay_user.where(date: @start_date..@end_date)
      
      @airpay_prev = 
        @airpay_user.where("? > date",@start_date)
        .where(result_point: nil)
        .or(@airpay_user.where("? > date",@start_date).where(result_point: @airpay1_start_date..@airpay1_end_date)) 
        @airpay_prev = 
          @airpay_prev.where(status: "審査完了")
          .or(@airpay_prev.where(status: "審査中"))
        @airpay_prev_len = @airpay_prev.length 
      @airpay_period_done_len = 
        @airpay_user.where("? > date",@start_date)
        .where(status: "審査完了")
        .where(result_point: @airpay1_start_date..@airpay1_end_date).length
      @airpay_result = 
      @airpay_period.where(status: "審査完了")
        .or(
          @airpay_period.where(status: "審査中")
        )
        @airpay_period_def_ng = @airpay_period.where(status: "審査NG")
        .or(
          @airpay_period.where(status: "代表者情報不備")
          )
        .or(
          @airpay_period.where(status: "店舗情報不備")
          )
        .or(
          @airpay_period.where(status: "口座情報不備")
          )
      if (@airpay_result.length == 0) || (@digestion_new == 0)
        @airpay_result_len_ave = 0
      else  
        @airpay_result_len_ave = (@airpay_result.length.to_f / @digestion_new).round(1) rescue 0
      end
      @airpay_done = 
        @airpay_user.where(status: "審査完了")
        .where(result_point: @airpay1_start_date..@airpay1_end_date)

      if @month.beginning_of_month >= @before_airpay_bonus_date
        @airpay_bonus =
        if @airpay_done.length >= @airpay_bonus2_len
          @airpay_done.length * (@airpay_bonus2_price - @airpay_price)
        elsif @airpay_done.length >= @airpay_bonus1_len
          @airpay_done.length * (@airpay_bonus1_price - @airpay_price)
        else  
          0
        end 
      else  
        @airpay_bonus =
        if @airpay_done.length >= 20
          @airpay_done.length * 3000
        elsif @airpay_done.length >= 10
          @airpay_done.length * 2000
        else  
          0
        end 
      end
        @airpay_done_val = @airpay_done.sum(:valuation) + @airpay_bonus


        # 出前館売上
        @demaekan = Demaekan.includes(:user).where(user_id: @user.id).where(first_cs_contract: @start_date..@end_date)
        @demaekan_len = @demaekan.length

      # 合計成果売上
      @valuation_sum = 
        @dmer_done.sum(:valuation_new) + 
        @dmer_slmt_done.sum(:valuation_settlement) + 
        @dmer_slmt2nd_done.sum(:valuation_second_settlement) + 
        @aupay_slmt_done.sum(:valuation_settlement) + 
        @paypay_done.sum(:valuation) + 
        @rakuten_pay_done_val + 
        @airpay_done_val +
        @aupay_pic_val + 
        @dmer_pic_val + 
        @demaekan.sum(:valuation)
      
      # 帯同Ave
      @ojt_val_ave = @valuation_sum / (@digestion_new + @digestion_settlement) rescue 0
      @ojt_val_sum = @ojt_val_ave * @digestion_ojt rescue 0
      # 成果売上終着
      # dメル
        # 過去の決済対象
        @dmer_slmt_tgt_prev = 
          @dmer_user.where("settlement_deadline >= ?",@start_date)
          .where("? > date", @start_date)
          .where(status: "審査OK")
          .where.not(industry_status: "×")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "要確認")
          @dmer1_slmt_tgt_prev = 
            @dmer_slmt_tgt_prev.where(result_point: @dmer1_start_date..@dmer1_end_date)
            .or(@dmer_slmt_tgt_prev.where(result_point: nil))
          @dmer2_slmt_tgt_prev = 
          @dmer_slmt_tgt_prev.where(status_update_settlement: @dmer2_start_date..@dmer2_end_date)
          .or(@dmer_slmt_tgt_prev.where(status_update_settlement: nil))
        # 期限切れ
        @dmer_slmt_dead = @dmer_slmt_tgt_prev.where(status_settlement: "期限切れ")
        @dmer_slmt_dead_len = @dmer_slmt_dead.length
        # 過去の決済対象で今月成果になったもの
        @dmer1_prev_val = 
          @dmer1_slmt_tgt_prev.where(result_point: @dmer1_start_date..@dmer1_end_date)
        @dmer1_prev_val_len = @dmer1_prev_val.length
        @dmer2_prev_val = 
          @dmer2_slmt_tgt_prev.where(status_update_settlement: @dmer2_start_date..@dmer2_end_date)
        @dmer2_prev_val_len = @dmer2_prev_val.length
        @dmer3_prev_val = 
          @dmer2_slmt_tgt_prev.where("? >= settlement_second", @dmer3_end_date)
        @dmer3_prev_val_len = @dmer3_prev_val.length
        # 第一成果終着
        # 終着獲得数
        @dmer_val1_period = 
          @dmer_user.where(status: "審査OK")
          .where.not(industry_status: "×")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "要確認")
          .where(date: @start_date...@dmer1_start_date) # 26~月末
          .where(result_point: @start_date...@dmer1_start_date) 
          @dmer_val2_period = @dmer_val1_period.where(status_update_settlement: @start_date...@dmer1_start_date).where(status_settlement: "完了")
          @dmer_val3_period = @dmer_val2_period.where(settlement_second: @start_date...@dmer1_start_date)
          # 前月26~末日までに成果まで踏んだ案件の売上
          @dmer_val1_period_profit = @dmer_val1_period.sum(:valuation_new)
          @dmer_val2_period_profit = @dmer_val2_period.sum(:valuation_settlement)
          @dmer_val3_period_profit = @dmer_val3_period.sum(:valuation_second_settlement)
          # 期間内終着
          @dmer_result1_fin_len = (@dmer_len_ave * @new_shift).round() rescue 0
        @dmer_result1_fin_this_month_len = (@dmer_len.to_f / @digestion_new * @new_shift * (@dmer1_this_month_per - @dmer1_dec_per)).round() rescue 0
        @dmer_result1_fin_this_month = 
          (@dmer1_price * @dmer_result1_fin_this_month_len) - @dmer_val1_period_profit
        # 過去月
        @dmer1_done_prev = @dmer_done.where("? > date",@start_date)
        @dmer1_done_prev_len = 
          (@dmer1_done_prev.length.to_f * (@dmer1_prev_month_per + @dmer1_prev_inc_per)).round()
        @dmer_result1_fin_prev_month_len = 
          (
            (@dmer1_slmt_tgt_prev.length - @dmer1_prev_val_len).to_f * 
            (@dmer1_prev_month_per - @dmer1_prev_dec_per)
          ).round()
        @dmer_result1_fin_prev_month = 
          (@dmer1_price * @dmer_result1_fin_prev_month_len) + 
          (@dmer1_price * @dmer1_done_prev_len)
          
        @dmer_result1_fin = @dmer_result1_fin_this_month + @dmer_result1_fin_prev_month 
        # 第二成果終着
        # 期間内終着
        @dmer_result2_fin_this_month_len = (@dmer_len.to_f / @digestion_new * @new_shift * (@dmer2_this_month_per - @dmer2_dec_per)).round() rescue 0
        @dmer_result2_fin_this_month = 
          (@dmer2_price * @dmer_result2_fin_this_month_len) - @dmer_val2_period_profit
        # 過去月
        @dmer2_done_prev = @dmer_slmt_done.where("? > date",@start_date)
        @dmer2_done_prev_len = (@dmer2_done_prev.length.to_f * (@dmer2_prev_month_per + @dmer2_prev_inc_per)).round()
        @dmer_result2_fin_prev_month_len = 
          ((@dmer2_slmt_tgt_prev.length - @dmer2_prev_val_len).to_f * (@dmer2_prev_month_per - @dmer2_prev_dec_per)).round()
        @dmer_result2_fin_prev_month = 
          (@dmer2_price * @dmer_result2_fin_prev_month_len) + (@dmer2_price * @dmer2_done_prev_len)
        @dmer_result2_fin = @dmer_result2_fin_this_month + @dmer_result2_fin_prev_month
        # 第三成果終着
        # 期間内
        @dmer_result3_fin_this_month_len = (@dmer_len.to_f / @digestion_new * @new_shift * (@dmer3_this_month_per - @dmer3_dec_per)).round() rescue 0
        @dmer_result3_fin_this_month = 
          (@dmer3_price * @dmer_result3_fin_this_month_len) - @dmer_val3_period_profit
        # 過去月
        @dmer_result3_fin_prev_month = 
          (@dmer3_price * (@dmer2_slmt_tgt_prev.length - @dmer3_prev_val_len - @dmer_slmt_dead_len)) + 
          @dmer_slmt2nd_done.where("? > date",@start_date).sum(:valuation_second_settlement)
        @dmer_result3_fin = @dmer_result3_fin_this_month + @dmer_result3_fin_prev_month
      # auPay
        # 過去の決済対象
        @aupay_slmt_tgt_prev = 
        @aupay_user.where("settlement_deadline >= ?", @start_date)
        .where("? > date", @start_date)
        .where(status: "審査通過")
        .where(status_update_settlement: nil)
        .or(
          @aupay_user.where("settlement_deadline >= ?", @start_date)
          .where("? > date", @start_date)
          .where(status: "審査通過")
          .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
        )
        # 過去の決済対象で今月成果になったもの
        @aupay_slmt_prev_val = 
          @aupay_slmt_tgt_prev.where(status_update_settlement: @start_date.next_month.beginning_of_month..@start_date.next_month.end_of_month)
          @aupay_slmt_prev_val_len = @aupay_slmt_prev_val.length
        @aupay_slmt_tgt_prev_len = @aupay_slmt_tgt_prev.length
        
        # 第一成果終着
        # 過去月
        @aupay_result1_fin_prev_month_len = 
           ((@aupay_slmt_tgt_prev_len - @aupay_slmt_prev_val_len) * @aupay1_prev_month_per).round() rescue 0
          @aupay_result1_fin_prev_month = (@aupay1_price * @aupay_result1_fin_prev_month_len) + @aupay_slmt_done.where(" ? > date",@start_date).sum(:valuation_settlement) rescue 0
        # 終着
        # @aupay_result1_fin_this_month +
        @aupay_result1_fin =  @aupay_result1_fin_prev_month
        
        # PayPay
          # 第一成果終着
          @paypay_fin_len = (@paypay_len_ave * @new_shift).round() rescue 0
          if @new_shift.present?
          @paypay_result1_fin = 
            if (@paypay_done.sum(:valuation) > (@paypay_price * @paypay_fin_len)) | (Date.today >= @start_date.next_month.end_of_month)
              @paypay_done.sum(:valuation)
            else
              @paypay_price * @paypay_fin_len rescue 0
            end
          else  
            @paypay_result1_fin = 0
          end

        # 楽天ペイ
            # 第一成果終着
            @rakuten_pay_result1_fin_len = (@rakuten_pay_len_ave * @new_shift * @rakuten_pay1_this_month_per).round() rescue 0
            @rakuten_pay_result1_fin = @rakuten_pay_price * @rakuten_pay_result1_fin_len rescue 0
              if (@rakuten_pay_done_val > @rakuten_pay_result1_fin) || (Date.today >= @start_date.next_month.end_of_month)
                @rakuten_pay_result1_fin = @rakuten_pay_done_val
              end
        # AirPay
              # 営業が終着に打ち込んだAirPayの件数
              @airpays_result_len = @results.sum(:airpay)
              @airpays_result_len_ave = (@airpays_result_len.to_f / @digestion_new).round(1)
              @airpays_result_len_fin = (@airpays_result_len.to_f / @digestion_new * @new_shift * (@airpay1_this_month_per - @airpay_dec_per)).round()
              #前月26~末日までに成果を踏んだ件数
              @airpay26_end_done = 
                @airpay_user.where(date: @start_date...@airpay1_start_date)
                .where(result_point: @start_date...@airpay1_start_date)
                .where(status: "審査完了")
            # 単価
            @airpay_result_len_fin = (@airpay_result_len_ave * @new_shift * @airpay1_this_month_per).round() rescue 0
            if @month.beginning_of_month >= @before_airpay_bonus_date
              if (@airpays_result_len_fin + @airpay_prev_len + @airpay_period_done_len) >= @airpay_bonus2_len
                @airpay_price = @airpay_bonus2_price
              elsif (@airpays_result_len_fin + @airpay_prev_len + @airpay_period_done_len) >= @airpay_bonus1_len
                @airpay_price = @airpay_bonus1_price
              else  
                @airpay_price = @airpay_price
              end
            else  
              if @airpays_result_len_fin >= 20
                @airpay_price = 6000
              elsif @airpays_result_len_fin >= 10
                @airpay_price = 5000
              else  
                @airpay_price = 3000
              end
            end
            # 期間内終着
            @airpay_result1_fin_this_month = @airpay_price * @airpays_result_len_fin - (@airpay26_end_done.length * @airpay_price) rescue 0
            # 過去月終着（審査中件数 * 0.87 + 過去月の売上）
            @airpay_result1_fin_prev_month = 
              @airpay_price * (
                ( @airpay_prev_len - @airpay_period_done_len) * 
                (@airpay1_prev_month_per - @airpay_prev_dec_per)
              ).round() + (@airpay_price * @airpay_period_done_len)
            # 合計 期間内終着 + 過去月終着 
            @airpay_result1_fin = @airpay_result1_fin_this_month + @airpay_result1_fin_prev_month
              if (@airpay_done_val > @airpay_result1_fin) || (Date.today >= @start_date.next_month.end_of_month)
                @airpay_result1_fin = @airpay_done_val rescue 0
              end
        # 成果終着
        @result_fin = 
          (
            @dmer_result1_fin +
            @dmer_result2_fin +
            @dmer_result3_fin +
            @aupay_result1_fin +
            @paypay_result1_fin +
            @rakuten_pay_result1_fin +
            @airpay_result1_fin +
            @aupay_pic_val +
            @dmer_pic_val +
            @demaekan.sum(:valuation)
          ).to_i
        if (@valuation_sum > @result_fin) || (Date.today >= @start_date.next_month.end_of_month)
          @result_fin = @valuation_sum
        end
        # 成果平均
        if @new_shift.present?
          @result_ave = @result_fin / (@new_shift + @settlement_shift)
        else  
          @result_ave = 0
        end
        

      @comment = Comment.new
      session[:previous_url] = user_path(@user.id)
      @comments = Comment.select(:id,:status, :content,:store_prop_id,:request_show,:request)
    end

    def summit_profit 
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
      def judge_inc(product, date)
        return product.where.not(date: date.minimum(:date)..date.minimum(:date).next_month.beginning_of_month.since(24.days))
          .where(status: "審査通過")
          .where(result_point: date.maximum(:date).beginning_of_month..date.minimum(:date).next_month.end_of_month)
          .or(product.where.not(date: date.minimum(:date)..date.minimum(:date).next_month.beginning_of_month.since(24.days))
          .where(status: "審査OK").where(result_point: date.maximum(:date).beginning_of_month..date.minimum(:date).next_month.end_of_month))
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
      # 絞り込んだ期間ではなく、不備解消が絞り込んだ期間のもの
      def inc_period(product,date)
        return product.where.not(date: date.minimum(:date)..date.maximum(:date)).where(deficiency_solution: date.minimum(:date)..date.maximum(:date))
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
