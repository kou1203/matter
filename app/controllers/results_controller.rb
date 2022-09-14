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
    @users_chubu = @users.where(base: "中部SS")
    @users_chubu_cash = @users_chubu.where(base_sub: "キャッシュレス")
    @users_kansai = @users.where(base: "関西SS")
    @users_kansai_cash = @users_kansai.where(base_sub: "キャッシュレス")
    @users_kanto = @users.where(base: "関東SS")
    @users_kanto_cash = @users_kanto.where(base_sub: "キャッシュレス")
    @users_partner = @users.where(base: "2次店")
    @user_partner_cash = @users_partner.where(base_sub: "キャッシュレス")
  # 終着データ
    @q = Result.ransack(params[:q])
    @results = 
    if params[:q].nil?
      Result.none 
    else    
      @q.result(distinct: false).includes(:user).joins(:user).order(date: :asc)
    end
    if @results.present?
      @minimum_result_cash = @results.minimum(:date) #26日
      @maximum_result_cash = @results.minimum(:date).beginning_of_month.since(1.month).since(24.days) #25日
      if @results.first.user.base == "中部SS"
        @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash).where(user: {base: "中部SS"})
      elsif @results.first.user.base == "関西SS"
        @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash).where(user: {base: "関西SS"})
      elsif @results.first.user.base == "関東SS"
      @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash).where(user: {base: "関東SS"})
      else
      @cash_result = @results.joins(:user).where(date: @minimum_result_cash..@maximum_result_cash)
      end
      @month = params[:month] ? Time.parse(params[:month]) : @results.minimum(:date)
    end
  # 日々獲得進捗
    @month_daily = params[:month] ? Date.parse(params[:month]) : Time.zone.today.yesterday #当日日付
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
  # 即時在庫
    @dmer_stock = DmerStock.where(date:@month_daily.all_month)
  # 目標獲得数
    @product_targets = ProductTarget.where(date: @month_daily.beginning_of_month..@month_daily.end_of_month)
    @dmer_target = @product_targets.where(product: "dメル")
    @aupay_target = @product_targets.where(product: "auPay")
    @rakuten_pay_target = @product_targets.where(product: "楽天ペイ")
    @airpay_target = @product_targets.where(product: "AirPay")
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
      @dmer_slmt_prev_month_chubu = @dmer_slmt_prev_month.where(user: {base: "中部SS"})
      @dmer_slmt_prev_month_kansai = @dmer_slmt_prev_month.where(user: {base: "関西SS"})
      @dmer_slmt_prev_month_kanto = @dmer_slmt_prev_month.where(user: {base: "関東SS"})
      @aupay_slmt_prev_month_chubu = @aupay_slmt_prev_month.where(user: {base: "中部SS"})
      @aupay_slmt_prev_month_kansai = @aupay_slmt_prev_month.where(user: {base: "関西SS"})
      @aupay_slmt_prev_month_kanto = @aupay_slmt_prev_month.where(user: {base: "関東SS"})
  # 現状売上
    if @month_daily.day >= 26
      @result_monthly = 
        Result.where(date: @month_daily.beginning_of_month.since(25.days)..@month_daily).includes(:user).select(:profit,:base_sub, :shift,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
        .or(
          Result.where(date: @month_daily.beginning_of_month.since(25.days)..@month_daily).includes(:user).select(:profit,:base_sub, :shift,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")
        )
      @shift_monthly =
        Shift.where(start_time: @month_daily.beginning_of_month.since(25.days)..@month_daily.beginning_of_month.next_month.since(24.days)).includes(:user)
        .where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
        .or(
          Shift.where(start_time: @month_daily.beginning_of_month.since(25.days)..@month_daily.beginning_of_month.next_month.since(24.days)).includes(:user).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")
        )
    else  
      @result_monthly = 
        Result.where(date: @month_daily.prev_month.beginning_of_month.since(25.days)..@month_daily).includes(:user).select(:profit,:base_sub, :shift,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
        .or(
          Result.where(date: @month_daily.prev_month.beginning_of_month.since(25.days)..@month_daily).includes(:user).select(:profit,:base_sub, :shift,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")
        )
      @shift_monthly =
        Shift.where(start_time: @month_daily.prev_month.beginning_of_month.since(25.days)..@month_daily.beginning_of_month.since(24.days)).includes(:user).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
        .or(
          Shift.where(start_time: @month_daily.prev_month.beginning_of_month.since(25.days)..@month_daily.beginning_of_month.since(24.days)).includes(:user).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")
        )
    end
  # 当日獲得数・売上
    @dmer_today_data = Dmer.where(date: @month_daily).includes(:user).select(:valuation_new,:base_sub,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"})
    @aupay_today_data = Aupay.where(date: @month_daily).includes(:user).includes(:user).select(:base_sub,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"})
    @paypay_today_data = Paypay.where(date: @month_daily).includes(:user).select(:valuation,:base_sub,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"})
    @rakuten_pay_today_data = RakutenPay.where(date: @month_daily).includes(:user).select(:valuation,:base_sub,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"})
    @airpay_today_data = Airpay.where(date: @month_daily).includes(:user).select(:valuation,:base_sub,:base,:date,:user_id).where(user: {base_sub: "キャッシュレス"})
    @result_today_data = Result.where(date: @month_daily).includes(:user).select(:profit, :user_id,:date,:shift,:base,:base_sub).where(user: {base_sub: "キャッシュレス"})
    @shift_today_data = 
      Shift.where(start_time: @month_daily).includes(:user).select(:user_id,:start_time,:shift,:base,:base_sub).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス新規")
      .or(
        Shift.where(start_time: @month_daily).includes(:user).select(:user_id,:start_time,:shift,:base,:base_sub).where(user: {base_sub: "キャッシュレス"}).where(shift: "キャッシュレス決済")
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
      @shifts = Shift.includes(:user).all
      # 個別利益表 
      if @results.group(:user_id).length == 1 
        # paypay
            @paypays_user = Paypay.where(user_id: @results.first.user_id )
            @paypays_this_month = this_period(@paypays_user,@results)
            @paypays_def_this_month = @paypays_this_month.where(status: "自社不備")
        # 少額短期保険
          @st_insurances_user = StInsurance.where(user_id: @results.first.user_id )
          @st_insurances_this_month = this_period(@st_insurances_user,@results)
          @st_insurances_def_this_month = this_period(@st_insurances_this_month,@results)
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
          @result_monthly
      else
      # 全体売上
        @shift_sum = this_period(@shifts,@results)
      end
  end 

  def new 
    @users = User.where.not(position: "退職")
    @result = Result.new 
  end 
  
  def create 
    @users = User.where.not(position: "退職")
    @result = Result.new(result_params)
    if @result.save 
      if @result.shift == "キャッシュレス新規"
        redirect_to  result_result_cashes_new_path(@result.id)
      elsif @result.shift == "キャッシュレス決済"
        redirect_to  result_result_cashes_new_path(@result.id)
      elsif @result.shift == "楽天フェムト新規"
        redirect_to  result_result_casas_new_path(@result.id)
      elsif @result.shift == "サミット"
        redirect_to  result_result_summits_new_path(@result.id)
      else  
        redirect_to results_path
      end  
    else  
      render :new 
    end
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
    if @result.shift == "キャッシュレス新規" && @result.result_cash.nil?
      redirect_to  result_result_cashes_new_path(@result.id)
    elsif @result.shift == "キャッシュレス決済" && @result.result_cash.nil?
      redirect_to  result_result_cashes_new_path(@result.id)
    elsif @result.shift == "キャッシュレス新規"
      redirect_to edit_result_cash_path(@result.result_cash.id)
    elsif @result.shift == "キャッシュレス決済"
      redirect_to edit_result_cash_path(@result.result_cash.id)
    elsif @result.shift == "楽天フェムト新規" && @result.result_cash.nil?
      redirect_to edit_result_casa_path(@result.result_casa.id)
    elsif @result.shift == "楽天フェムト新規"
      redirect_to  result_result_cashes_new_path(@result.id)
    elsif @result.shift == "サミット" && @result.result_cash.nil?
      redirect_to edit_result_summit_path(@result.result_summit.id)
    elsif @result.shift == "サミット"
      redirect_to  result_result_summits_new_path(@result.id)
    else  
      redirect_to session[:previous_url]
    end
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
    @users = 
      User.where.not(position: "退職").or(User.where(position: nil))
  end 

  def ranking
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @results = Result.where(date: @month.prev_month.beginning_of_month.since(25.days)..@month.beginning_of_month.since(24.days))
    @minimum_result_cash = @results.minimum(:date)
    @maximum_result_cash = @results.maximum(:date)
    @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash)
    @minimum_date_cash = @month.prev_month.beginning_of_month.since(25.days)
    @maximum_date_cash = @month.beginning_of_month.since(24.days)
    @dmers = Dmer.where(date: @minimum_date_cash..@maximum_date_cash)
    @aupays = Aupay.where(date: @minimum_date_cash..@maximum_date_cash)
    @rakuten_pays = RakutenPay.where(date: @minimum_date_cash..@maximum_date_cash)
    @airpays = Airpay.where(date: @minimum_date_cash..@maximum_date_cash)
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

  def profit 
  # 期間
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @start_date = @month.prev_month.beginning_of_month.since(25.days) # 26日
    @end_date = @month.beginning_of_month.since(24.days) # 25日
    @start_done = @month.beginning_of_month # 月初
    @end_done = @month.end_of_month # 月末
    @results = Result.includes(:user).where(date: @start_date..@end_date)
    @shifts = 
      Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
      .or(
        Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス決済")
      )
  # ハッシュ・リストデータ
    @chubu_cash_list = []
    @kansai_cash_list = []
    @kanto_cash_list = []
    @partner_cash_list = []
    @femto_list = []
    @bases = ["中部SS", "関西SS", "関東SS", "2次店"]
    @users = 
      User.where(base_sub: "キャッシュレス").where.not(position: "退職")
      .or(
        User.where(base_sub: "フェムト").where.not(position: "退職")
      )
  # ハッシュの中身
    @bases.each do |base| # 拠点ごとに繰り返す
      @users.where(base: base).each do |user| #ユーザーごとに繰り返す
        person_hash = {}
        user_result = @results.where(user_id: user.id)
        person_hash["名前"] = user.name
      # 予定シフト
        user_shift = @shifts.where(user_id: user.id)
        person_hash["予定シフト"] = user_shift.length
        person_hash["予定新規シフト"] = user_shift.where(shift: "キャッシュレス新規").length
        person_hash["予定決済シフト"] = user_shift.where(shift: "キャッシュレス決済").length
        person_hash["予定決済シフト"] = user_shift.where(shift: "キャッシュレス決済").length
      # 消化シフト
        user_result_shift = 
          user_result.where(shift: "キャッシュレス新規")
            .or(
              user_result.where(shift: "キャッシュレス決済")
            )
        person_hash["消化シフト"] = user_result_shift.length 
        person_hash["消化新規シフト"] = user_result_shift.where(shift: "キャッシュレス新規").length 
        person_hash["消化決済シフト"] = user_result_shift.where(shift: "キャッシュレス決済").length 
      # 基準値
        person_hash["訪問"] = user_result.sum("first_total_visit + latter_total_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["応答"] = user_result.sum("first_visit + latter_visit") / person_hash["消化新規シフト"] rescue 0
        person_hash["対面"] = user_result.sum("first_interview + latter_interview") / person_hash["消化新規シフト"] rescue 0
        person_hash["フル"] = user_result.sum("first_full_talk + latter_full_talk") / person_hash["消化新規シフト"] rescue 0
        person_hash["獲得"] = user_result.sum("first_get + latter_get") / person_hash["消化新規シフト"] rescue 0
      # 現状売上
      # dメル
        dmer_user = 
          Dmer.where(user_id: user.id).where(status: "審査OK")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
        dmer_slmter = 
          Dmer.where(settlementer_id: user.id)
          .where(status: "審査OK")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status_settlement: "完了")
        # 第一成果
        dmer_result1 = 
          dmer_user.where(result_point: @start_done..@end_done)
          .where("? >= settlement", @end_done)
          .or(
            dmer_user.where(settlement: @start_done..@end_done)
            .where("? >= result_point", @end_done)
          )
        dmer_result1_profit = dmer_result1.sum(:profit_new)
        person_hash["dメル現状売上1"] = dmer_result1_profit
        # 第二成果
        dmer_result2 = dmer_slmter.where(status_update_settlement: @start_done..@end_done)
          dmer_result2_profit = dmer_result2.sum(:profit_settlement)
        person_hash["dメル現状売上2"] = dmer_result2_profit
        # 第三成果
        dmer_result3 = 
          dmer_slmter.where(settlement_second: @start_done..@end_done)
          .where("? >= status_update_settlement",@end_done)
          .or(
            dmer_slmter.where(settlement_second: @start_done..@end_done)
            .where("? >= settlement_second",@end_done)
          )
        dmer_result3_profit = dmer_result3.sum(:profit_second_settlement)
        person_hash["dメル現状売上3"] = dmer_result3_profit
      # auPay
          aupay_slmter = 
            Aupay.where(settlementer_id: user.id).where(status: "審査通過")
            .where(status_settlement: "完了")
          # 一次成果
          aupay_result1 = aupay_slmter.where(status_update_settlement: @start_done..@end_done)
          aupay_result1_profit = aupay_result1.sum(:profit_settlement)
          person_hash["auPay現状売上1"] = aupay_result1_profit
      #PayPay
          
      # ハッシュへデータを配列へ格納
        if user.base_sub =="フェムト"
          @femto_list << person_hash
        elsif base == "中部SS"
          @chubu_cash_list << person_hash
        elsif base == "関西SS"
          @kansai_cash_list << person_hash
        elsif base == "関東SS"
          @kanto_cash_list << person_hash
        elsif base == "2次店"
          @partner_cash_list << person_hash
        end 
      end #ユーザーごとに繰り返す
    end # 拠点ごとに繰り返す
    
    
    
  end 


  private
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
    )
  end 
end
