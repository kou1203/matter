class ResultsController < ApplicationController
  before_action :authenticate_user!
  def index
    # 商材情報
    @dmers = 
      Dmer.eager_load(:store_prop).select("dmers.id,dmers.user_id,dmers.store_prop_id")
      .where(store_prop: {head_store: nil})
      .where.not(status: "自社不備")
      .where.not(status: "自社NG")
    @aupays = 
      Aupay.eager_load(:store_prop).select("aupays.id,aupays.user_id,aupays.store_prop_id")
      .where(store_prop: {head_store: nil})
      .where.not(status: "自社不備")
      .where.not(status: "自社NG")
    @paypays = Paypay.select("paypays.id,paypays.user_id")
    @rakuten_pays = RakutenPay.select("rakuten_pays.id,rakuten_pays.user_id")
    # ユーザー情報
    @users = 
      User.where.not(position: "退職").or(User.where(position: nil))
    @users_cash = @users.where(base_sub: "キャッシュレス").order(base: "DESC")
    # キャッシュレス
    @users_chubu = @users.where(base: "中部SS")
    @users_chubu_cash = @users_chubu.where(base_sub: "キャッシュレス")
    @users_chubu_summit = @users_chubu.where(base_sub: "サミット")
    @users_kansai = @users.where(base: "関西SS")
    @users_kansai_cash = @users_kansai.where(base_sub: "キャッシュレス")
    @users_kansai_summit = @users_kansai.where(base_sub: "サミット")
    @users_kanto = @users.where(base: "関東SS")
    @users_kanto_cash = @users_kanto.where(base_sub: "キャッシュレス")
    @users_kanto_summit = @users_kanto.where(base_sub: "サミット")
    @users_kyushu = @users.where(base: "九州SS")
    @users_kyushu_cash = @users_kyushu.where(base_sub: "キャッシュレス")
    @users_partner = @users.where(base: "2次店")
    @user_partner_cash = @users_partner.where(base_sub: "キャッシュレス")
    # 終着データ
    @result_category = "拠点別終着"
    @q = Result.ransack(params[:q])
    @results = 
    if params[:q].nil?
      Result.none 
    else    
      @q.result(distinct: false).includes(:user).joins(:user).order(date: :asc)
    end
    if @results.present?
      @month = params[:month] ? Time.parse(params[:month]) : Date.today
      @calc_periods = CalcPeriod.where(sales_category: "評価売")
      @month_result = params[:month] ? Time.parse(params[:month]) : @results.minimum(:date)
      calc_period_and_per
      @minimum_result_cash = @results.minimum(:date) #26日
      @maximum_result_cash = @results.minimum(:date).beginning_of_month.since(1.month).since(24.days) #25日
      if @results.first.user.base == "中部SS"
        @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash).where(user: {base: "中部SS"})
      elsif @results.first.user.base == "関西SS"
        @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash).where(user: {base: "関西SS"})
      elsif @results.first.user.base == "関東SS"
      @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash).where(user: {base: "関東SS"})
      elsif @results.first.user.base == "九州SS"
      @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash).where(user: {base: "九州SS"})
      else
      @cash_result = @results.joins(:user).where(date: @minimum_result_cash..@maximum_result_cash)
      end
      @cash_result_out = @cash_result.includes(:result_cash).select(:result_cash_id, :user_id)
    end
    # 日々獲得進捗
    # 検索（現状）
    if params[:date].present?
      @month_daily = params[:date].to_date
    elsif params[:search_date].present?
      @month_daily = params[:search_date].to_date  
    else
      @month_daily = Date.today #当日日付
    end 
    # 検索（比較対象）
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
    else  
      @comparison_date = @month_daily.prev_month
    end 

    @dmer_monthly = 
        Dmer.where(date: @month_daily.beginning_of_month..@month_daily).includes(:user).where(user: {base_sub: "キャッシュレス"})
    @aupay_monthly = 
        Aupay.where(date: @month_daily.beginning_of_month..@month_daily).includes(:user).where(user: {base_sub: "キャッシュレス"})
    @paypay_monthly = 
        Paypay.where(date: @month_daily.beginning_of_month..@month_daily).includes(:user).where(user: {base_sub: "キャッシュレス"})
    @rakuten_pay_monthly = 
        RakutenPay.where(date: @month_daily.beginning_of_month..@month_daily).includes(:user).where(user: {base_sub: "キャッシュレス"})
    @airpay_monthly = 
        Airpay.where(date: @month_daily.beginning_of_month..@month_daily).includes(:user).where(user: {base_sub: "キャッシュレス"})
    @result_demaekan = Result.includes(:result_cash,:user).select(:user_id,:result_id,:date)
    @shift_monthly_plan = 
      Shift.includes(:user)
      .where(start_time: @month_daily.beginning_of_month..@month_daily.end_of_month)
      .where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
    @shift_monthly_slmt_plan = 
      Shift.includes(:user)
      .where(start_time: @month_daily.beginning_of_month..@month_daily.end_of_month)
      .where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")
    @shift_monthly_digestion = 
      Result.includes(:user)
      .where(date: @month_daily.beginning_of_month..@month_daily)
      .select(:id,:date,:user_id).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
    @shift_monthly_slmt_digestion = 
      Result.includes(:user)
      .where(date: @month_daily.beginning_of_month..@month_daily)
      .select(:id,:date,:user_id).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")

    @dmer_comparison = 
        Dmer.where(date: @comparison_date.beginning_of_month..@comparison_date).includes(:user).where(user: {base_sub: "キャッシュレス"})
    @aupay_comparison = 
        Aupay.where(date: @comparison_date.beginning_of_month..@comparison_date).includes(:user).where(user: {base_sub: "キャッシュレス"})
    @paypay_comparison = 
        Paypay.where(date: @comparison_date.beginning_of_month..@comparison_date).includes(:user).where(user: {base_sub: "キャッシュレス"})
    @rakuten_pay_comparison = 
        RakutenPay.where(date: @comparison_date.beginning_of_month..@comparison_date).includes(:user).where(user: {base_sub: "キャッシュレス"})
    @airpay_comparison = 
        Airpay.where(date: @comparison_date.beginning_of_month..@comparison_date).includes(:user).where(user: {base_sub: "キャッシュレス"})
    @result_demaekan = Result.includes(:result_cash,:user).select(:user_id,:result_id,:date)
    @shift_comparison_plan = 
      Shift.includes(:user)
      .where(start_time: @comparison_date.beginning_of_month..@comparison_date.end_of_month)
      .where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
    @shift_comparison_slmt_plan = 
      Shift.includes(:user)
      .where(start_time: @comparison_date.beginning_of_month..@comparison_date.end_of_month)
      .where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")
    @shift_comparison_digestion = 
      Result.includes(:user)
      .where(date: @comparison_date.beginning_of_month..@comparison_date)
      .select(:id,:date,:user_id).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
    @shift_comparison_slmt_digestion = 
      Result.includes(:user)
      .where(date: @comparison_date.beginning_of_month..@comparison_date)
      .select(:id,:date,:user_id).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")

    # 月間決済率
    # 当月
    @dmer_slmt_this_month = 
      @dmer_monthly.where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      @aupay_slmt_this_month =
      @aupay_monthly.where(status: "審査通過")
      @dmer_slmt_this_month_chubu = @dmer_slmt_this_month.where(user: {base: "中部SS"})
      @dmer_slmt_this_month_kansai = @dmer_slmt_this_month.where(user: {base: "関西SS"})
      @dmer_slmt_this_month_kanto = @dmer_slmt_this_month.where(user: {base: "関東SS"})
      @aupay_slmt_this_month_chubu = @aupay_slmt_this_month.where(user: {base: "中部SS"})
      @aupay_slmt_this_month_kansai = @aupay_slmt_this_month.where(user: {base: "関西SS"})
      @aupay_slmt_this_month_kanto = @aupay_slmt_this_month.where(user: {base: "関東SS"})
    # 過去月
    @dmer_slmt_prev_month = 
      Dmer.includes(:user).where("? > date",@month_daily.beginning_of_month)
      .where("settlement_deadline > ?",@month_daily.beginning_of_month)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    @aupay_slmt_prev_month = 
      Aupay.includes(:user).where("? > date",@month_daily.beginning_of_month)
      .where("settlement_deadline > ?",@month_daily.beginning_of_month)
      .where(status_update_settlement: nil)
      .where(status: "審査通過")
      .or(
        Aupay.where("? > date",@month_daily.beginning_of_month)
        .where("settlement_deadline > ?",@month_daily.beginning_of_month)
        .where(status_update_settlement: @month_daily.beginning_of_month..@month_daily.end_of_month)
        .where(status: "審査通過")
      )
    # 拠点が増えた場合↓を追加
    @chubu_slmt = []
    @kansai_slmt = []
    @kanto_slmt = []
    @kyushu_slmt = []
    @users_cash.each do |user|
      person_hash = {}
      person_hash["拠点"] = user.base 
      person_hash["氏名"] = user.name 
      # dメル
      person_hash["dメル当月決済対象"] = @dmer_slmt_this_month.where(user_id: user.id).length
      person_hash["dメル当月決済完了数"] = @dmer_slmt_this_month.where(user_id: user.id).where(status_settlement: "完了").length
      person_hash["dメル当月決済完了率"] = (person_hash["dメル当月決済完了数"].to_f / person_hash["dメル当月決済対象"].to_f * 100).round() rescue 0
      person_hash["dメル過去月決済対象"] = @dmer_slmt_prev_month.where(user_id: user.id).length
      person_hash["dメル過去月決済完了数"] = @dmer_slmt_prev_month.where(user_id: user.id).where(status_settlement: "完了").length
      person_hash["dメル過去月決済完了率"] =( person_hash["dメル過去月決済完了数"].to_f / person_hash["dメル過去月決済対象"].to_f * 100).round() rescue 0
      # au
      person_hash["auPay当月決済対象"] = @aupay_slmt_this_month.where(user_id: user.id).length
      person_hash["auPay当月決済完了数"] = @aupay_slmt_this_month.where(user_id: user.id).where(status_settlement: "完了").length
      person_hash["auPay当月決済完了率"] = (person_hash["auPay当月決済完了数"].to_f / person_hash["auPay当月決済対象"].to_f * 100).round() rescue 0
      person_hash["auPay過去月決済対象"] = @aupay_slmt_prev_month.where(user_id: user.id).length
      person_hash["auPay過去月決済完了数"] = @aupay_slmt_prev_month.where(user_id: user.id).where(status_settlement: "完了").length
      person_hash["auPay過去月決済完了率"] =( person_hash["auPay過去月決済完了数"].to_f / person_hash["auPay過去月決済対象"].to_f * 100).round() rescue 0
      # 拠点が増えた場合↓を追加
      if user.base == "中部SS"
        @chubu_slmt << person_hash
      elsif user.base == "関西SS"
        @kansai_slmt << person_hash
      elsif user.base == "関東SS"
        @kanto_slmt << person_hash
      elsif user.base == "九州SS"
        @kyushu_slmt << person_hash
      else
      end
    end

    # 現状売上
      @result_monthly = 
        Result.where(date: @month_daily.beginning_of_month..@month_daily).includes(:user).select(:profit,:base_sub, :shift,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
        .or(
          Result.where(date: @month_daily.beginning_of_month..@month_daily).includes(:user).select(:profit,:base_sub, :shift,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")
        )
      @shift_monthly =
        Shift.where(start_time: @month_daily.beginning_of_month..@month_daily.beginning_of_month.next_month.since(24.days)).includes(:user)
        .where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
        .or(
          Shift.where(start_time: @month_daily.beginning_of_month..@month_daily.beginning_of_month.next_month.since(24.days)).includes(:user).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")
        )
      # 当月不備
      @dmer_def = Dmer.includes(:store_prop,:user).where(store_prop: {head_store: nil}).where(status: "不備対応中")
      @dmer_def_this_month = 
        @dmer_def.where(date: @month_daily.beginning_of_month..@month_daily.end_of_month)
      @dmer_def_prev_month = 
        @dmer_def.where(date: @month_daily.beginning_of_month.prev_month..@month_daily.end_of_month.prev_month)
      @aupay_def = 
        Aupay.includes(:store_prop,:user)
        .where(status: "差し戻し")
        .where.not(deficiency_remarks: "既存auPAY加盟店の登録がすでにあるため、差し戻しさせていただきます。")
        .where(store_prop: {head_store: nil})
      @aupay_def_this_month = 
        @aupay_def.where(date: @month_daily.beginning_of_month..@month_daily.end_of_month)
      @aupay_def_prev_month = 
        @aupay_def.where(date: @month_daily.prev_month.beginning_of_month..@month_daily.prev_month.end_of_month)
      @rakuten_pay_def = RakutenPay.includes(:user).where(status: "自社不備")
      @rakuten_pay_def_this_month = 
        @rakuten_pay_def.where(date: @month_daily.beginning_of_month..@month_daily.end_of_month)
      @rakuten_pay_def_prev_month = 
        @rakuten_pay_def.where(date: @month_daily.prev_month.beginning_of_month..@month_daily.prev_month.end_of_month)
    # 日付が~25までは前月の26日が初日と計算するようにする
    if 26 > @month_daily.day
      @shift_month = 
        Shift.includes(:user)
        .where(start_time: @month_daily.prev_month.beginning_of_month.since(25.days)..@month_daily.beginning_of_month.since(24.days))
      @result_month = Result.includes(:user).where(date: @month_daily.prev_month.beginning_of_month.since(25.days)..@month_daily)
      @result_yesterday = Result.includes(:user).where(date: @month_daily.prev_month.beginning_of_month.since(25.days)..@month_daily.yesterday)
      @result_last_month = Result.includes(:user).where(date: @month_daily.ago(2.month).beginning_of_month.since(25.days)..@month_daily.prev_month.beginning_of_month.since(24.days))
      @dmer_month = Dmer.includes(:user).all
      @dmer_slmt_month = Dmer.includes(:user).all
      @dmer_2ndslmt_month = Dmer.includes(:user).all
      @aupay_month = Aupay.includes(:user).all
      @aupay_slmt_month = Aupay.includes(:user).all
      @rakuten_pay_month = RakutenPay.includes(:user).all
      @paypay_month = Paypay.includes(:user).all
    else
      @shift_month = Shift.includes(:user).where(start_time: @month_daily.beginning_of_month.since(25.days)..@month_daily.next_month.beginning_of_month.since(24.days))
      @result_month = Result.includes(:user).where(date: @month_daily.beginning_of_month.since(25.days)..@month_daily)
      @result_yesterday = Result.includes(:user).where(date: @month_daily.beginning_of_month.since(25.days)..@month_daily.yesterday)
      @result_last_month = Result.includes(:user).where(date: @month_daily.prev_month.beginning_of_month.since(25.days)..@month_daily
      .beginning_of_month.since(24.days))
      @dmer_month = Dmer.includes(:user).all
      @dmer_slmt_month = Dmer.includes(:user).all
      @dmer_2ndslmt_month = Dmer.includes(:user).all
      @aupay_month = Aupay.includes(:user).all
      @aupay_slmt_month = Aupay.includes(:user).all
      @rakuten_pay_month = RakutenPay.includes(:user).all
      @paypay_month = Paypay.includes(:user).all
    end
  end 

  def new 
    @users = User.where.not(position: "退職")
    @result = Result.new(user_id: params[:user_id],date: params[:date])
    session[:previous_url] = request.referer
  end 
  
  def create 
    @users = User.where.not(position: "退職")
    @result = Result.new(result_params)
    if @result.save 
      if @result.shift == "キャッシュレス新規"
        redirect_to  result_result_cashes_new_path(@result.id)
      elsif @result.shift == "キャッシュレス決済"
        redirect_to  result_result_cashes_new_path(@result.id)
      elsif @result.shift == "電気" || @result.shift == "設置電気"
        redirect_to  result_result_summits_new_path(@result.id)
      else  
        redirect_to session[:previous_url]
      end  
    else  
      render :new 
    end
  end

  def show 
    @calc_periods = CalcPeriod.where(sales_category: "評価売")
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    
    # calc_period_and_perは"@calc_periods"と"@month"の配置を先にするのが必須
    calc_period_and_per
    @user = User.find(params[:id])
    # 月間増減
    # dメル
    @dmers = Dmer.includes(:store_prop).where(date: @start_date..@end_date).where(user_id: @user.id)
    @dmers_inc = 
      Dmer.includes(:store_prop).where.not(date: @start_date..@end_date)
      .where(user_id: @user.id).where(store_prop: {head_store: nil})
      .where(status: "審査OK").where.not(industry_status: "×").where.not(industry_status: "NG")
      .where(result_point: @start_date..@end_date)
    @dmers_dec = 
      Dmer.includes(:store_prop).where(date: @start_date..@end_date)
      .where(user_id: @user.id).where(store_prop: {head_store: nil})
      .where(status: "審査OK").where.not(industry_status: "×").where.not(industry_status: "NG")
      .where.not(result_point: @start_date..@end_date)
    @dmers_db = Dmer.includes(:store_prop).where.not(store_prop: {head_store: nil}).where(date: @start_date..@end_date).where(user_id: @user.id)
    @dmer_done = 
      Dmer.where(user_id: @user.id).where(result_point: @dmer1_start_date..@dmer1_end_date)
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      .where(status: "審査OK")
    @dmers_slmt = 
      Dmer.where(settlementer_id: @user.id).where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    @dmer_slmt_done = 
      @dmers_slmt.where(status_update_settlement: @dmer2_start_date..@dmer2_end_date)
      .where(status_settlement: "完了").or(
        @dmers_slmt.where(status_update_settlement: ..@dmer2_end_date)
        .where(result_point: @dmer2_start_date..@dmer2_end_date)
        .where(status_settlement: "完了")

      )
    @dmer_slmt2nd_done = 
    @dmers_slmt.where(settlement_second: @dmer3_start_date..@dmer3_end_date)
    .where(status_settlement: "完了")
    .where(status_update_settlement: ..@dmer3_end_date)
    .or(
      @dmers_slmt.where(settlement_second: ..@dmer3_end_date)
      .where(status_settlement: "完了")
      .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
    )
    @dmers_slmt_done = @dmers_slmt.where(settlement: @start_date..@end_date).where(status_settlement: "完了")
    @dmers_slmt_def = @dmers_slmt.where(status_settlement: "決済不備")
    @dmers_slmt_pic_def = @dmers_slmt.where(status_settlement: "写真不備")
    @dmers_slmt2nd_done = @dmers_slmt.where(settlement_second: @start_date..@end_date).where(status_settlement: "完了")
    @aupays = Aupay.includes(:store_prop).where(date: @start_date..@end_date).where(user_id: @user.id)
    @aupays_inc = 
      Aupay.includes(:store_prop).where(result_point: @start_date..@end_date).where(user_id: @user.id)
      .where(store_prop: {head_store: nil}).where.not(date: @start_date..@end_date).where(status: "審査通過")
    @aupays_dec = 
      Aupay.includes(:store_prop).where.not(result_point: @start_date..@end_date).where(user_id: @user.id)
      .where(store_prop: {head_store: nil}).where(date: @start_date..@end_date).where(status: "審査通過")
      @aupays_db = Aupay.includes(:store_prop).where(date: @start_date..@end_date).where.not(store_prop: {head_store: nil}).where(user_id: @user.id)
    @aupays_slmt = Aupay.where(settlementer_id: @user.id).where(status: "審査通過")
    @aupays_slmt_done = @aupays_slmt.where(settlement: @start_date..@end_date).where(status_settlement: "完了")
    @aupays_slmt_def = @aupays_slmt.where(status_settlement: "決済不備")
    @aupays_slmt_pic_def = @aupays_slmt.where(status_settlement: "写真不備")

    @aupay_slmt_done = 
    @aupays_slmt.where(status_update_settlement: @aupay1_start_date..@aupay1_end_date).where(status_settlement: "完了")

    @paypays = Paypay.where(date: @start_date..@end_date).where(user_id: @user.id)
    @paypay_done = 
        Paypay.where(user_id: @user.id).where(result_point: @paypay1_start_date..@paypay1_end_date)
        .where(status: "60審査可決")
    if @month.year == 2023 && @month.month == 2
      start_d = Date.new(2023,1,26)
      end_d = Date.new(2023,2,28)
      @rakuten_pays = RakutenPay.where(user_id: @user.id).where(date: start_d..end_d)
    else
      @rakuten_pays = RakutenPay.where(user_id: @user.id).where(date: @rakuten_pay1_start_date..@rakuten_pay1_end_date)
    end
    @rakuten_pay_val = 
      @rakuten_pays.where.not(status: "自社NG").where.not(status: "自社不備")
      .where(deficiency: nil)
      .or(
        RakutenPay.where(user_id: @user.id).where.not(status: "自社NG").where.not(status: "自社不備")
        .where.not(deficiency: nil)
        .where(share: @rakuten_pay1_start_date..@rakuten_pay1_end_date)
        )
    @rakuten_pay_uq = RakutenPay.includes(:store_prop).where(date: @rakuten_pay1_start_date..@rakuten_pay1_end_date).where(user_id: @user.id)
    @rakuten_pays_inc = 
      RakutenPay.includes(:store_prop)
      .where.not(date: @rakuten_pay1_start_date..@rakuten_pay1_end_date).where(user_id: @user.id)
      .where(share: @rakuten_pay1_start_date..@rakuten_pay1_end_date).where.not(deficiency: nil)
    @rakuten_pays_dec = RakutenPay.includes(:store_prop).where(date: @rakuten_pay1_start_date..@rakuten_pay1_end_date).where(user_id: @user.id)
    .where.not(share: @rakuten_pay1_start_date..@rakuten_pay1_end_date).where.not(deficiency: nil)

    @rakuten_pay_def_ng = 
      @rakuten_pays.where(status: "自社不備")
      .or(@rakuten_pays.where(status: "自社NG"))
      .or(@rakuten_pays.where.not(deficiency: nil).where.not(share: @rakuten_pay1_start_date..@rakuten_pay1_end_date))
    @rakuten_pay_val_len = @rakuten_pay_val.length
    @airpays = Airpay.includes(:store_prop).where(date: @start_date..@end_date).where(user_id: @user.id)
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

    @airpay_val_len = @airpays.length - @airpay_def_ng.length
    @airpay_user = Airpay.where(user_id: @user.id)
    @airpay_done = 
      @airpay_user.where(status: "審査完了")
      .where(result_point: @airpay1_start_date..@airpay1_end_date)
      @airpay_bonus =
        if @airpay_done.length >= 20
          @airpay_done.length * 3000
        elsif @airpay_done.length >= 10
          @airpay_done.length * 2000
        else  
          0
        end 

    @airpay_done_val = @airpay_done.sum(:valuation) + @airpay_bonus

    # その他獲得商材
    @demaekan = Demaekan.where(user_id: @user.id).where(first_cs_contract: @demaekan1_start_date..@demaekan1_end_date)
    @other_products = OtherProduct.where(user_id: @user.id).where(date: @month.beginning_of_month..@month.end_of_month)
    @aupay_pic = @other_products.where(product_name: "auPay写真")
    @dmer_pic = @other_products.where(product_name: "dメルステッカー")
    @airpay_pic = AirpaySticker.where(user_id: @user.id).where(form_send: @month.beginning_of_month..@month.end_of_month).where(sticker_ok: "〇").where(pop_ok: "〇")
    # ITSS
    @itss = Itss.includes(:user).where(user_id: @user.id).where(construction_schedule: @itss1_start_date..@itss1_end_date)
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
      .where(date: @month.ago(2.month)..@month.end_of_month)
      .where(status: "自社不備")
      .where(user_id: @user.id)
      .or(
        RakutenPay.includes(:store_prop, :user)
        .where(status: "1次審査不備")
        .where(user_id: @user.id)
      ) 

    @comment = Comment.new
    session[:previous_url] = user_path(@user.id)
    @comments = Comment.select(:id,:status, :content,:store_prop_id,:request_show,:request)

    # 利益表
      @date_period = (@start_date..@end_date)
      @results = Result.includes(:user, :result_cash).where(user_id: @user.id).where(date: @start_date..@end_date)
      @shifts = Shift.where(user_id: @user.id).where(start_time: @start_date..@end_date)
    # 各種商材などの件数や売上
      @cash_date_progress = CashDateProgress.where(user_id: @user.id).where(date: @date_period).last
      @dmer_date_progress = DmerDateProgress.where(user_id: @user.id).where(date: @date_period).last
      @aupay_date_progress = AupayDateProgress.where(user_id: @user.id).where(date: @date_period).last
      @paypay_date_progress = PaypayDateProgress.where(user_id: @user.id).where(date: @date_period).last
      @rakuten_pay_date_progress = RakutenPayDateProgress.where(user_id: @user.id).where(date: @date_period).last
      @airpay_date_progress = AirpayDateProgress.where(user_id: @user.id).where(date: @date_period).last
      @demaekan_date_progress = DemaekanDateProgress.where(user_id: @user.id).where(date: @date_period).last
      @austicker_date_progress = AustickerDateProgress.where(user_id: @user.id).where(date: @date_period).last
      @dmersticker_date_progress = DmerstickerDateProgress.where(user_id: @user.id).where(date: @date_period).last
      @airpaysticker_date_progress = AirpaystickerDateProgress.where(user_id: @user.id).where(date: @date_period).last

      @dmers_val_len = @dmer_date_progress.get_len - @dmer_date_progress.def_len rescue 0
      @aupays_val_len = @aupay_date_progress.get_len - @aupay_date_progress.def_len rescue 0
    # シフト
      @shift_schedule_new = @shifts.where(shift: "キャッシュレス新規").length
      @shift_schedule_slmt = @shifts.where(shift: "キャッシュレス決済").length
      @shift_schedule_ojt = @shifts.where(shift: "帯同").length
      @shift_digestion_new = @results.where(shift: "キャッシュレス新規").length
      @shift_digestion_slmt = @results.where(shift: "キャッシュレス決済").length
      @shift_digestion_ojt = @results.where(shift: "帯同").length
    if @shift_digestion_new.present?
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
      @visit10_ave = (@visit10_sum.to_f / @shift_digestion_new).round(1)
      @get10_sum = @results.sum(:get10)
      @get10_ave = (@get10_sum.to_f / @shift_digestion_new).round(1)

      @visit11_sum = @results.sum(:visit11)
      @visit11_ave = (@visit11_sum.to_f / @shift_digestion_new).round(1)
      @get11_sum = @results.sum(:get11)
      @get11_ave = (@get11_sum.to_f / @shift_digestion_new).round(1)

      @visit12_sum = @results.sum(:visit12)
      @visit12_ave = (@visit12_sum.to_f / @shift_digestion_new).round(1)
      @get12_sum = @results.sum(:get12)
      @get12_ave = (@get12_sum.to_f / @shift_digestion_new).round(1)

      @visit13_sum = @results.sum(:visit13)
      @visit13_ave = (@visit13_sum.to_f / @shift_digestion_new).round(1)
      @get13_sum = @results.sum(:get13)
      @get13_ave = (@get13_sum.to_f / @shift_digestion_new).round(1)

      @visit14_sum = @results.sum(:visit14)
      @visit14_ave = (@visit14_sum.to_f / @shift_digestion_new).round(1)
      @get14_sum = @results.sum(:get14)
      @get14_ave = (@get14_sum.to_f / @shift_digestion_new).round(1)

      @visit15_sum = @results.sum(:visit15)
      @visit15_ave = (@visit15_sum.to_f / @shift_digestion_new).round(1)
      @get15_sum = @results.sum(:get15)
      @get15_ave = (@get15_sum.to_f / @shift_digestion_new).round(1)

      @visit16_sum = @results.sum(:visit16)
      @visit16_ave = (@visit16_sum.to_f / @shift_digestion_new).round(1)
      @get16_sum = @results.sum(:get16)
      @get16_ave = (@get16_sum.to_f / @shift_digestion_new).round(1)

      @visit17_sum = @results.sum(:visit17)
      @visit17_ave = (@visit17_sum.to_f / @shift_digestion_new).round(1)
      @get17_sum = @results.sum(:get17)
      @get17_ave = (@get17_sum.to_f / @shift_digestion_new).round(1)

      @visit18_sum = @results.sum(:visit18)
      @visit18_ave = (@visit18_sum.to_f / @shift_digestion_new).round(1)
      @get18_sum = @results.sum(:get18)
      @get18_ave = (@get18_sum.to_f / @shift_digestion_new).round(1)

      @visit19_sum = @results.sum(:visit19)
      @visit19_ave = (@visit19_sum.to_f / @shift_digestion_new).round(1)
      @get19_sum = @results.sum(:get19)
      @get19_ave = (@get19_sum.to_f / @shift_digestion_new).round(1)

      @time_visit_sum = [@visit10_sum,@visit11_sum,@visit12_sum,@visit13_sum,@visit14_sum,@visit15_sum,@visit16_sum,@visit17_sum,@visit18_sum,@visit19_sum]
      @time_visit_ave = [@visit10_ave,@visit11_ave,@visit12_ave,@visit13_ave,@visit14_ave,@visit15_ave,@visit16_ave,@visit17_ave,@visit18_ave,@visit19_ave]
      @time_get_sum = [@get10_sum,@get11_sum,@get12_sum,@get13_sum,@get14_sum,@get15_sum,@get16_sum,@get17_sum,@get18_sum,@get19_sum]
      @time_get_ave = [@get10_ave,@get11_ave,@get12_ave,@get13_ave,@get14_ave,@get15_ave,@get16_ave,@get17_ave,@get18_ave,@get19_ave]
    # 拠点別基準値
      @result_base = Result.includes(:user, :result_cash).where(date: @start_date..@end_date)
      @result_chubu = @result_base.where(user: {base: "中部SS"})
      @result_kansai = @result_base.where(user: {base: "関西SS"})
      @result_kanto = @result_base.where(user: {base: "関東SS"})
      @result_kyushu = @result_base.where(user: {base: "九州SS"})
      @result_partner = @result_base.where(user: {base: "2次店"})
      # 拠点別切り返し
      @result_cash_base = ResultCash.includes(:result,result: :user).where(result: {date: @start_date..@end_date})
      @result_cash_chubu = @result_cash_base.where(user: {base: "中部SS"})
      @result_cash_kansai = @result_cash_base.where(user: {base: "関西SS"})
      @result_cash_kanto = @result_cash_base.where(user: {base: "関東SS"})
      @result_cash_kyushu = @result_cash_base.where(user: {base: "九州SS"})
      @result_cash_partner = @result_cash_base.where(user: {base: "2次店"})
      @hour_visit_chubu = []
      @hour_get_chubu = []
      @hour_visit_kansai = []
      @hour_get_kansai = []
      @hour_visit_kanto = []
      @hour_get_kanto = []
      @hour_visit_kyushu = []
      @hour_get_kyushu = []
      @hour_visit_partner = []
      @hour_get_partner = []
      10.times do |i|
        @hour_visit_chubu << @result_chubu.sum("visit#{i + 10}") rescue 0
        @hour_get_chubu << @result_chubu.sum("get#{i + 10}") rescue 0
        @hour_visit_kansai << @result_kansai.sum("visit#{i + 10}") rescue 0
        @hour_get_kansai << @result_kansai.sum("get#{i + 10}") rescue 0
        @hour_visit_kanto << @result_kanto.sum("visit#{i + 10}") rescue 0
        @hour_get_kanto << @result_kanto.sum("get#{i + 10}") rescue 0
        @hour_visit_kyuhsu << @result_kyuhsu.sum("visit#{i + 10}") rescue 0
        @hour_get_kyuhsu << @result_kyuhsu.sum("get#{i + 10}") rescue 0
        @hour_visit_partner << @result_partner.sum("visit#{i + 10}") rescue 0
        @hour_get_partner << @result_partner.sum("get#{i + 10}") rescue 0
      end 

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
          @results_week = Result.includes(:result_cash).where(user_id: @user.id)
          @results_week1 = @results_week.where(date: week1..(week1.since(6.days)))
          @results_week2 = @results_week.where(date: (week1.since(7.days))..(week1.since(13.days)))
          @results_week3 = @results_week.where(date: (week1.since(14.days))..(week1.since(20.days)))
          @results_week4 = @results_week.where(date: (week1.since(21.days))..(week1.since(27.days)))
          @results_week5 = @results_week.where(date: (week1.since(28.days))..(week1.since(34.days)))
      end

      # 増減
      @dmer_def = 
      @dmers.where(status: "自社不備")
      .or(@dmers.where(status: "審査NG"))
      .or(@dmers.where(status: "不備対応中"))
      .or(@dmers.where(status: "申込取消"))
      .or(@dmers.where(status: "申込取消（不備）"))
      .or(@dmers.where(status: "社内確認中"))
      .or(@dmers.where(industry_status: "NG"))
      .or(@dmers.where(industry_status: "×"))
      .or(@dmers.where(industry_status: "要確認"))
      @dmer_inc = 
      Dmer.includes(:store_prop).where(user_id: @user.id).where.not(date: @dmer1_start_date..@dmer1_end_date)
      .where(result_point: @dmer1_start_date..@dmer1_end_date)
      .where(store_prop: {head_store: nil})
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      .where(status: "審査OK")
      @dmer_db_data = 
      Dmer.includes(:store_prop).where(user_id: @user.id).where(share: @dmer1_start_date..@dmer1_end_date)
        .where.not(store_prop: {head_store: nil})
        .where.not(industry_status: "×")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "要確認")
        .where(status: "審査OK")
      @aupay_def =  
      @aupays.where(status: "自社不備")
        .or(@aupays.where(status: "不合格"))
        .or(@aupays.where(status: "差し戻し"))
        .or(@aupays.where(status: "解約"))
        .or(@aupays.where(status: "報酬対象外"))
        .or(@aupays.where(status: "重複対象外"))
      
      @aupay_dec = 
        Airpay.includes(:store_prop).where(user_id: @user.id).where(date: @start_date..@end_date)
        .where(status: "審査通過")
        .where(store_prop: {head_store: nil})
        .where.not(result_point: @start_date..@end_date)

      @aupay_inc = 
        Airpay.includes(:store_prop).where(user_id: @user.id).where.not(date: @start_date..@end_date)
        .where(result_point: @start_date..@end_date)
        .where(status: "審査通過")
        .where(store_prop: {head_store: nil})
      
        @aupay_db = 
          Airpay.includes(:store_prop).where(user_id: @user.id).where(result_point: @start_date..@end_date)
          .where.not(store_prop: {head_store: nil})
          .where(status: "審査通過")

        @rakuten_pay_def =  
          @rakuten_pay_uq.where(status: "自社不備")
          .or(@rakuten_pay_uq.where(status: "自社NG"))
          .or(
            @rakuten_pay_uq.where(deficiency: @start_date..@end_date)
            .where.not(deficiency_solution: @start_date..@end_date)
          )

        @rakuten_pay_inc = 
        RakutenPay.includes(:store_prop).where(user_id: @user.id)
          .where.not(deficiency: @start_date..@end_date)
          .where(deficiency_solution: @start_date..@end_date)
    end 




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

  def import 
    if params[:file].present?
      if Result.csv_check(params[:file]).present?
        redirect_to results_path , alert: "エラーが発生したため中断しました#{Result.csv_check(params[:file])}"
      else
        message = Result.import(params[:file]) 
        redirect_to results_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to results_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def edit 
    @result = Result.find(params[:id])
    session[:previous_url] = request.referer
  end 
  
  def update 
    @result = Result.find(params[:id])
    @result.update(result_params)
      redirect_to session[:previous_url]
  end

  def destroy 
    @result = Result.find(params[:id])
    @result.destroy
    redirect_to request.referer
  end 

  def date_progress
    # 日々進捗
    @month_daily = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    @results_week = 
      Result.preload(:user).eager_load(:result_cash).where(date: @month_daily.ago(2.days)..@month_daily)
      @dmers = 
      Dmer.eager_load(:store_prop).select("dmers.id,dmers.user_id,dmers.store_prop_id")
      .where(store_prop: {head_store: nil})
      .where.not(status: "自社不備")
      .where.not(status: "自社NG")
    @aupays = 
      Aupay.eager_load(:store_prop).select("aupays.id,aupays.user_id,aupays.store_prop_id")
      .where(store_prop: {head_store: nil})
      .where.not(status: "自社不備")
      .where.not(status: "自社NG")
    @paypays = Paypay.select("paypays.id,paypays.user_id")
    @rakuten_pays = RakutenPay.select("rakuten_pays.id,rakuten_pays.user_id")
    @airpays = Airpay.eager_load(:store_prop).select("airpays.id, airpays.user_id,airpays.store_prop_id,airpays.status")
    @users = 
      User.where.not(position: "退職").or(User.where(position: nil))
  end 

  def daily_report
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @calc_periods = CalcPeriod.where(sales_category: "評価売")
    calc_period_and_per
    @base_category = params[:base_category]
    @results = Result.includes(:result_cash,:user).where(user: {base: @base_category}).where(user: {base_sub: "キャッシュレス"}).where(date: @start_date..@month)
    @shift_digestion = 
      @results.where(shift: "キャッシュレス新規")
      .or(
        @results.where(shift: "キャッシュレス決済")
      )
    @shifts = 
      Shift.includes(:user).where(start_time: @start_date..(@month.since(1.days) - 1.minutes)).where(user: {base: @base_category}).where(shift: "キャッシュレス新規").where(user: {base_sub: "キャッシュレス"})
      .or(
        Shift.includes(:user).where(start_time: @start_date..(@month.since(1.days) - 1.minutes)).where(user: {base: @base_category}).where(shift: "キャッシュレス決済").where(user: {base_sub: "キャッシュレス"})

      ).order(position_sub: :asc)
    @shift_schedule = 
      Shift.includes(:user).where(start_time: @start_date..@end_date).where(user: {base: @base_category}).where(shift: "キャッシュレス新規").where(user: {base_sub: "キャッシュレス"})
      .or(
        Shift.includes(:user).where(start_time: @start_date..@end_date).where(user: {base: @base_category}).where(shift: "キャッシュレス決済").where(user: {base_sub: "キャッシュレス"})

      ).order(position_sub: :asc)
    @shift = 
      Shift.includes(:user).where(start_time: @month..(@month.since(1.days) - 1.minutes)).where(user: {base: @base_category}).where(shift: "キャッシュレス新規").where(user: {base_sub: "キャッシュレス"})
      .or(
        Shift.includes(:user).where(start_time: @month..(@month.since(1.days) - 1.minutes)).where(user: {base: @base_category}).where(shift: "キャッシュレス決済").where(user: {base_sub: "キャッシュレス"})

      ).order(position_sub: :asc)
    @result = 
      Result.includes(:user, :result_cash).where(date: @month).where(user: {base: @base_category}).where(shift: "キャッシュレス新規")
      .or(
        Result.includes(:user, :result_cash).where(date: @month).where(user: {base: @base_category}).where(shift: "キャッシュレス決済")

      )
    @users = User.where(base: @base_category).where(base_sub: "キャッシュレス").where.not(position: "退職").order(position_sub: :asc)

  end 

  # ランキング
  def ranking
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @calc_periods = CalcPeriod.where(sales_category: "評価売")
    calc_period_and_per
    @users = User.where(base_sub: "キャッシュレス").where.not(position: "退職").order("users.position_sub ASC").order("users.id ASC")
    @cash_date_progress = CashDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @cash_date_progress = @cash_date_progress.where(date: @cash_date_progress.maximum(:date)).where(create_date: @cash_date_progress.maximum(:create_date)).order("valuation_fin DESC")
    @ranking_ave = {}
    @cash_date_progress.each do |r|
      sum_valuations_ave = (r.valuation_fin.to_f / r.shift_schedule).round() rescue 0
      @ranking_ave.store(r.user.name,[sum_valuations_ave])
      ranking_ave = @ranking_ave.sort {|(k1,v1), (k2,v2)| v2<=>v1}.to_h
    end



    @dmer_date_progress = DmerDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @dmer_date_progress = @dmer_date_progress.where(date: @dmer_date_progress.maximum(:date)).where(create_date: @dmer_date_progress.maximum(:create_date)).order("get_len DESC")
    @aupay_date_progress = AupayDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @aupay_date_progress = @aupay_date_progress.where(date: @aupay_date_progress.maximum(:date)).where(create_date: @aupay_date_progress.maximum(:create_date)).order("get_len DESC")
    @rakuten_pay_date_progress = RakutenPayDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @rakuten_pay_date_progress = @rakuten_pay_date_progress.where(date: @rakuten_pay_date_progress.maximum(:date)).where(create_date: @rakuten_pay_date_progress.maximum(:create_date)).order("get_len DESC")
    @airpay_date_progress = AirpayDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @airpay_date_progress = @airpay_date_progress.where(date: @airpay_date_progress.maximum(:date)).where(create_date: @airpay_date_progress.maximum(:create_date)).order("get_len DESC")
  end

  # 利益計算用終着
  def gross_profit
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @calc_periods = CalcPeriod.where(sales_category: "評価売")
    calc_period_and_per
    @cash_date_progress = 
      CashDateProgress.includes(:user).where(date: @start_date..@end_date)
      .where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
      .where.not(user: {base: "2次店"})
    @cash_date_progress = 
      @cash_date_progress.where(date: @cash_date_progress.maximum(:date))
      .where(create_date: @cash_date_progress.maximum(:create_date))
      .order("position_sub")
  end 

  def base_profit
    @base = params[:base]
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @calc_periods = CalcPeriod.where(sales_category: "評価売")
    calc_period_and_per
    @results = Result.includes(:user,:result_cash).where(user: {base: @base}).where(date: @start_date..@end_date)
    @users = User.where(base: @base).where(base_sub: "キャッシュレス").where.not(position: "退職").order("users.position_sub ASC").order("users.id ASC")
    @cash_date_progress = CashDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @cash_date_progress = @cash_date_progress.where(date: @cash_date_progress.maximum(:date)).where(create_date: @cash_date_progress.maximum(:create_date))
    @dmer_date_progress = DmerDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @dmer_date_progress = @dmer_date_progress.where(date: @dmer_date_progress.maximum(:date)).where(create_date: @dmer_date_progress.maximum(:create_date))
    @aupay_date_progress = AupayDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @aupay_date_progress = @aupay_date_progress.where(date: @aupay_date_progress.maximum(:date)).where(create_date: @aupay_date_progress.maximum(:create_date))
    @rakuten_pay_date_progress = RakutenPayDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @rakuten_pay_date_progress = @rakuten_pay_date_progress.where(date: @rakuten_pay_date_progress.maximum(:date)).where(create_date: @rakuten_pay_date_progress.maximum(:create_date))
    @airpay_date_progress = AirpayDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @airpay_date_progress = @airpay_date_progress.where(date: @airpay_date_progress.maximum(:date)).where(create_date: @airpay_date_progress.maximum(:create_date))
    @paypay_date_progress = PaypayDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @paypay_date_progress = @paypay_date_progress.where(date: @paypay_date_progress.maximum(:date)).where(create_date: @paypay_date_progress.maximum(:create_date))
    @airpaysticker_date_progress = AirpaystickerDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @airpaysticker_date_progress = @airpaysticker_date_progress.where(date: @airpaysticker_date_progress.maximum(:date)).where(create_date: @airpaysticker_date_progress.maximum(:create_date))
    @austicker_date_progress = AustickerDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @austicker_date_progress = @austicker_date_progress.where(date: @austicker_date_progress.maximum(:date)).where(create_date: @austicker_date_progress.maximum(:create_date))
    @dmersticker_date_progress = DmerstickerDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @dmersticker_date_progress = @dmersticker_date_progress.where(date: @dmersticker_date_progress.maximum(:date)).where(create_date: @dmersticker_date_progress.maximum(:create_date))
    @demaekan_date_progress = DmerstickerDateProgress.includes(:user).where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @demaekan_date_progress = @demaekan_date_progress.where(date: @demaekan_date_progress.maximum(:date)).where(create_date: @demaekan_date_progress.maximum(:create_date))
    @itss_date_progress = OtherProductDateProgress.includes(:user).where(product_name: "ITSS").where(date: @start_date..@end_date).where(user: {base: @base}).where(user: {base_sub: "キャッシュレス"}).where.not(user: {position: "退職"})
    @itss_date_progress = @itss_date_progress.where(date: @itss_date_progress.maximum(:date)).where(create_date: @itss_date_progress.maximum(:create_date))
    
  end 

  def dup_index
    @user_id = params[:user_id]
    @date = params[:date]
    @results = Result.where(user_id: @user_id).where(date: @date)
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




  private
    # 利益表を出力するための関数
    # @calc_periods, @month, @result_category
    # 上記3点をvaluation_packより上に配置して設定する必要があります。
    def valuation_pack 
      calc_period_and_per
      @results = Result.where(date: @month.prev_month.beginning_of_month.since(25.days)..@month.beginning_of_month.since(24.days))
      @month_result = params[:month] ? Time.parse(params[:month]) : @results.minimum(:date)
      @minimum_result_cash = @results.minimum(:date)
      @maximum_result_cash = @results.maximum(:date)
      @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash)
      @minimum_date_cash = @month.prev_month.beginning_of_month.since(25.days)
      @maximum_date_cash = @month.beginning_of_month.since(24.days)
      @dmers = Dmer.includes(:user).where.not(user: {base: "2次店"}).where(date: @minimum_date_cash..@maximum_date_cash)
      @aupays = Aupay.includes(:user).where.not(user: {base: "2次店"}).where(date: @minimum_date_cash..@maximum_date_cash)
      @rakuten_pays = RakutenPay.includes(:user).where.not(user: {base: "2次店"}).where(date: @minimum_date_cash..@maximum_date_cash)
      @airpays = Airpay.includes(:user).where.not(user: {base: "2次店"}).where(date: @minimum_date_cash..@maximum_date_cash)
      @dmers_rank = {}
      @dmers.group(:user_id).each do |dmer| 
        @dmers_rank.store(dmer.user.name,@dmers.where(user_id: dmer.user_id).length)
      end 
      @dmers_rank = @dmers_rank.sort {|(k1,v1), (k2,v2)| v2<=>v1}.to_h
      @aupays_rank = {}
      @aupays.group(:user_id).each do |aupay| 
        @aupays_rank.store(aupay.user.name,@aupays.where(user_id: aupay.user_id).length)
      end 
      @aupays_rank = @aupays_rank.sort {|(k1,v1), (k2,v2)| v2<=>v1}.to_h
      @rakuten_pays_rank = {}
      @rakuten_pays.group(:user_id).each do |rakuten_pay| 
        @rakuten_pays_rank.store(rakuten_pay.user.name,@rakuten_pays.where(user_id: rakuten_pay.user_id).length)
      end 
      @rakuten_pays_rank = @rakuten_pays_rank.sort {|(k1,v1), (k2,v2)| v2<=>v1}.to_h
      @airpays_rank = {}
      @airpays.group(:user_id).each do |airpay| 
        @airpays_rank.store(airpay.user.name,@airpays.where(user_id: airpay.user_id).length)
      end 
      @airpays_rank = @airpays_rank.sort {|(k1,v1), (k2,v2)| v2<=>v1}.to_h
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
          # .or(product.where(status: "審査OK")
          # .where.not(result_point: date.minimum(:date)..date.maximum(:date).end_of_month))
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
      return product.where(status_update_settlement: date.minimum(:date)..date.maximum(:date))
        .where(status: "審査OK").where(status_settlement: "完了")
        .or(product.where(status_update_settlement: date.minimum(:date)..date.maximum(:date))
        .where(status: "審査通過").where(status_settlement: "完了"))
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

    def slmt_second(product,date)
      return product.where(client: "ピアズ").where(status: "審査OK").where(status_settlement: "完了").where(settlement_second: date.minimum(:date)..date.maximum(:date))
    end 

    def slmt2nd_dead_line(product,date)
      return product.where(client: "ピアズ")
        .where(settlement_deadline: date.minimum(:date)
        .prev_month..date.maximum(:date).since(3.month).end_of_month)
        .where(status: "審査OK")
        .where(settlement: Date.new(2021-12-01)..date.maximum(:date).prev_month.end_of_month)
        .where(settlement_second: date.minimum(:date)..date.maximum(:date))
        .or(product.where(client: "ピアズ")
        .where(settlement_deadline: date.minimum(:date).prev_month..date.maximum(:date).since(3.month).end_of_month)
        .where(status: "審査OK")
        .where(settlement: Date.new(2021-12-01)..date.maximum(:date)
        .prev_month.end_of_month).where(settlement_second: nil))
    end
  # dメル,aupayメソッド

  # 楽天フェムトメソッド
    def casa_cancel(product, date)
      return product.where(date: date.minimum(:date)..date.maximum(:date)).where(status: "キャンセル")
    end
  # 楽天フェムトメソッド

  def result_params
    params.require(:result).permit(
      :user_id,
      :date,
      :area,
      :shift,
      :ojt_id, 
      :profit,
      :product,
      :ojt_start,
      :ojt_end,
      :remarks,
    # 基準値
      # 前半
      :first_total_visit,
      :first_visit,
      :first_interview,
      :first_full_talk, 
      :first_get,       
      # 後半 
      :latter_total_visit,
      :latter_visit,     
      :latter_interview, 
      :latter_full_talk, 
      :latter_get,       
    # 店舗別基準値
      # 喫茶・カフェ
      :cafe_visit,          
      :cafe_get,            
      # その他・飲食
      :other_food_visit,             
      :other_food_get       ,     
      # 車屋
      :car_visit          ,
      :car_get            ,
      # その他小売
      :other_retail_visit  ,        
      :other_retail_get            ,
      # 美容・理容
      :hair_salon_visit          ,
      :hair_salon_get            ,
      # 整体・鍼灸
      :manipulative_visit         , 
      :manipulative_get            ,
      # その他・サービス
      :other_service_visit          ,
      :other_service_get    ,
      # 時間別訪問
      :visit10,
      :visit11,
      :visit12,
      :visit13,
      :visit14,
      :visit15,
      :visit16,
      :visit17,
      :visit18,
      :visit19,
      :visit20,
      :get10,
      :get11,
      :get12,
      :get13,
      :get14,
      :get15,
      :get16,
      :get17,
      :get18,
      :get19,
      :get20,
    # サミット基準値
      :first_full_talk2,
      :latter_full_talk2,
      :revisit_full_talk,
      :revisit_get,
    )
  end 


end
