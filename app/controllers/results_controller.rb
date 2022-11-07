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
      elsif @results.first.user.base == "九州SS"
      @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash).where(user: {base: "九州SS"})
      else
      @cash_result = @results.joins(:user).where(date: @minimum_result_cash..@maximum_result_cash)
      end
      @month = params[:month] ? Time.parse(params[:month]) : @results.minimum(:date)
      @cash_result_out = @cash_result.includes(:result_cash).select(:result_cash_id, :user_id)
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
    @result_demaekan = Result.includes(:result_cash,:user).select(:user_id,:result_id,:date)
    @demaekan_monthly = @result_demaekan.where(date: @month_daily.beginning_of_month..@month_daily).where(user: {base_sub: "キャッシュレス"})
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
      elsif @result.shift == "サミット"
        redirect_to  result_result_summits_new_path(@result.id)
      else  
        redirect_to session[:previous_url]
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
    @airpays = 
      @airpays.where(status: "審査完了")
      .or(@airpays.where(status: "審査中"))
      .or(@airpays.where(status: "審査OK"))
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

  def gross_profit
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

  def valuation_pack
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
    # 単価
      # 単価
      dmer_price_1 = 8000
      dmer_price_2 = 4000
      dmer_price_3 = 5000
      aupay_price = 8000
      paypay_price = 1000
      rakuten_pay_price = 4000
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
              .or(user_result.where(shift: "キャッシュレス決済"))
              .or(user_result.where(shift: "帯同"))
          person_hash["消化シフト"] = user_result_shift.length 
          person_hash["消化新規シフト"] = user_result_shift.where(shift: "キャッシュレス新規").length 
          person_hash["消化決済シフト"] = user_result_shift.where(shift: "キャッシュレス決済").length 
          person_hash["消化帯同シフト"] = user_result_shift.where(shift: "帯同").length 
          user_result26_10 = user_result_shift.where(shift: "キャッシュレス新規").where(date: @start_date..@end_date.beginning_of_month.since(9.days)).length
        # 基準値
          person_hash["訪問"] = (user_result.sum("first_total_visit + latter_total_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["応答"] = (user_result.sum("first_visit + latter_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["対面"] = (user_result.sum("first_interview + latter_interview").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["フル"] = (user_result.sum("first_full_talk + latter_full_talk").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["獲得"] = (user_result.sum("first_get + latter_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
        # 切り返し
          person_hash["０１：どうゆうこと？：対面"] = (user_result.sum("out_interview_01").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０１：どうゆうこと？：フル"] = (user_result.sum("out_full_talk_01").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０１：どうゆうこと？：成約"] = (user_result.sum("out_get_01").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０２：君は誰？協会？：対面"] = (user_result.sum("out_interview_02").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０２：君は誰？協会？：フル"] = (user_result.sum("out_full_talk_02").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０２：君は誰？協会？：成約"] = (user_result.sum("out_get_02").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０３：もらうだけでいいの？：対面"] = (user_result.sum("out_interview_03").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０３：もらうだけでいいの？：フル"] = (user_result.sum("out_full_talk_03").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０３：もらうだけでいいの？：成約"] = (user_result.sum("out_get_03").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０４：PayPayのみ：対面"] = (user_result.sum("out_interview_04").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０４：PayPayのみ：フル"] = (user_result.sum("out_full_talk_04").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０４：PayPayのみ：成約"] = (user_result.sum("out_get_04").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０５：AirPayのみ：対面"] = (user_result.sum("out_interview_05").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０５：AirPayのみ：フル"] = (user_result.sum("out_full_talk_05").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０５：AirPayのみ：成約"] = (user_result.sum("out_get_05").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０６：カードのみ：対面"] = (user_result.sum("out_interview_06").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０６：カードのみ：フル"] = (user_result.sum("out_full_talk_06").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０６：カードのみ：成約"] = (user_result.sum("out_get_06").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０７：先延ばし：対面"] = (user_result.sum("out_interview_07").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０７：先延ばし：フル"] = (user_result.sum("out_full_talk_07").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０７：先延ばし：成約"] = (user_result.sum("out_get_07").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０８：現金のみ：対面"] = (user_result.sum("out_interview_08").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０８：現金のみ：フル"] = (user_result.sum("out_full_talk_08").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０８：現金のみ：成約"] = (user_result.sum("out_get_08").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０９：忙しい：対面"] = (user_result.sum("out_interview_09").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０９：忙しい：フル"] = (user_result.sum("out_full_talk_09").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["０９：忙しい：成約"] = (user_result.sum("out_get_09").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１０：面倒くさい：対面"] = (user_result.sum("out_interview_10").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１０：面倒くさい：フル"] = (user_result.sum("out_full_talk_10").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１０：面倒くさい：成約"] = (user_result.sum("out_get_10").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１１：情報不足：対面"] = (user_result.sum("out_interview_11").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１１：情報不足：フル"] = (user_result.sum("out_full_talk_11").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１１：情報不足：成約"] = (user_result.sum("out_get_11").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１２：ペロ：対面"] = (user_result.sum("out_interview_12").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１２：ペロ：フル"] = (user_result.sum("out_full_talk_12").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１２：ペロ：成約"] = (user_result.sum("out_get_12").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１３：その他：対面"] = (user_result.sum("out_interview_13").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１３：その他：フル"] = (user_result.sum("out_full_talk_13").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["１３：その他：成約"] = (user_result.sum("out_get_13").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["喫茶・カフェ訪問数"] = (user_result.sum("cafe_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["喫茶・カフェ獲得数"] = (user_result.sum("cafe_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他飲食訪問数"] = (user_result.sum("other_food_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他飲食獲得数"] = (user_result.sum("other_food_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["車屋訪問数"] = (user_result.sum("car_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["車屋獲得数"] = (user_result.sum("car_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他小売訪問数"] = (user_result.sum("other_retail_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他小売獲得数"] = (user_result.sum("other_retail_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["理容・美容訪問数"] = (user_result.sum("hair_salon_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["理容・美容獲得数"] = (user_result.sum("hair_salon_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["整体・鍼灸訪問数"] = (user_result.sum("manipulative_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["整体・鍼灸獲得数"] = (user_result.sum("manipulative_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他サービス訪問数"] = (user_result.sum("other_service_visit").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
          person_hash["その他サービス獲得数"] = (user_result.sum("other_service_get").to_f / person_hash["消化新規シフト"]).round(1) rescue 0
        # dメル
          dmer_user = 
            Dmer.where(user_id: user.id).includes(:store_prop)
          dmer_slmter = 
            Dmer.where(settlementer_id: user.id)
          # 現状売上
            # 第一成果
            dmer_result1 = 
              dmer_user.where(result_point: @start_done..@end_done)
              .where(status: "審査OK")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "×")
              .where.not(industry_status: "要確認")
            dmer_result1_valuation = dmer_result1.sum(:valuation_new)
            person_hash["dメル第一成果件数"] = dmer_result1.length
            person_hash["dメル現状売上1"] = dmer_result1_valuation
            # 第二成果
            dmer_result2 = 
              dmer_slmter.where(status_update_settlement: @start_done..@end_done)
              .where(status: "審査OK")
              .where.not(industry_status: "NG")
              .where.not(industry_status: "×")
              .where.not(industry_status: "要確認")
              .where(status_settlement: "完了")

              dmer_result2_valuation = dmer_result2.sum(:valuation_settlement)
            person_hash["dメル第二成果件数"] = dmer_result2.length
            person_hash["dメル現状売上2"] = dmer_result2_valuation
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
            dmer_result3_valuation = dmer_result3.sum(:valuation_second_settlement)
            person_hash["dメル第三成果件数"] = dmer_result3.length
            person_hash["dメル現状売上3"] = dmer_result3_valuation
          
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
              dmer_slmt2nd_valuations = dmer_result3.sum(:valuation_second_settlement)
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
                ) + (dmer_result3.where("? > date",@start_date).sum(:valuation_second_settlement))
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
              aupay_result1_valuation = aupay_result1.sum(:valuation_settlement)
              person_hash["auPay獲得数"] = aupay_uq.length
              person_hash["auPayアクセプタンス数"] = aupay_slmter.where(picture: @start_date..@end_date).length
              person_hash["auPay第一成果件数"] = aupay_result1.length
              person_hash["auPay現状売上1"] = aupay_result1_valuation
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
            paypay_result1_valuation = paypay_result1.sum(:valuation)
            person_hash["PayPay獲得数"] = paypay_uq.length
            person_hash["PayPay第一成果件数"] = paypay_result1.length
            person_hash["PayPay現状売上"] = paypay_result1_valuation
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
            if (paypay_result1_valuation > paypay_result1_fin) || (Date.today >= @closing_date)
              paypay_result1_fin = paypay_result1_valuation
            end 
            person_hash["PayPay一次成果終着"] = paypay_result1_fin
        # 楽天ペイ
          rakuten_pay_user = RakutenPay.includes(:store_prop).where(user_id: user.id)
          # 一次成果
          rakuten_pay_uq = rakuten_pay_user.where(date: @start_date..@end_date)
          rakuten_pay_def =  
          rakuten_pay_uq.where(status: "自社不備")
          .or(rakuten_pay_uq.where(status: "自社NG"))
          .or(
            rakuten_pay_uq.where(deficiency: @start_date..@end_date)
            .where.not(deficiency_solution: @start_date..@end_date)
          )
          rakuten_pay_inc = 
          rakuten_pay_user.where.not(date: @start_date..@end_date)
          .where(share: @start_date..@end_date)
          .where.not(deficiency: nil)
          rakuten_pay_val_len = rakuten_pay_uq.length - rakuten_pay_def.length + rakuten_pay_inc.length
          person_hash["楽天ペイ獲得数"] = rakuten_pay_uq.length
          person_hash["楽天ペイ第一成果件数"] = rakuten_pay_val_len
          person_hash["楽天ペイ現状売上"] = rakuten_pay_uq.sum(:valuation) + rakuten_pay_inc.sum(:valuation) - rakuten_pay_def.sum(:valuation)
          # 終着売上
          rakuten_pay_ave = rakuten_pay_val_len.to_f / person_hash["消化新規シフト"]
          rakuten_pay_fin = (rakuten_pay_ave * person_hash["予定新規シフト"] * 0.9).round() * rakuten_pay_price
          person_hash["楽天ペイ一次成果終着"] = rakuten_pay_fin
          if (person_hash["楽天ペイ現状売上"] >= person_hash["楽天ペイ一次成果終着"]) || (Date.today >= @closing_date)
            rakuten_pay_fin = person_hash["楽天ペイ現状売上"]
          end 
        # AirPay
          results = Result.includes(:user,:result_cash).where(date: @start_date..@end_date)
          result_user = results.where(user_id: user.id)
          @result_airpay_sum = result_user.sum(:airpay)

          airpay_user_len = Airpay.where(user_id: user.id).where(date: @start_date..@end_date).length
          airpay_len_ave = @result_airpay_sum.to_f / person_hash["消化新規シフト"] rescue 0
          airpay_len_fin = (airpay_len_ave * person_hash["予定新規シフト"] * airpay_result_per_prev).round() rescue 0
          if airpay_len_fin >= 20
            airpay_price = 8000
          elsif airpay_len_fin >= 10
            airpay_price = 6000
          else  
            airpay_price = 3000
          end 
          # 一次成果
          airpay_user = 
            Airpay.where(user_id: user.id).where(status: "審査完了")
            .or(Airpay.where(user_id: user.id).where(status: "審査中"))
          
          airpay_result1 = airpay_user.where(status: "審査完了").where(result_point: @start_done..@end_done)
          airpay_result1_valuation = airpay_result1.sum(:valuation) + (airpay_result1.length * (airpay_price - 3000)) 
          person_hash["AirPay第一成果件数"] = airpay_result1.length
          person_hash["AirPay現状売上"] = airpay_result1_valuation
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
          airpay_result1_fin = 
            airpay_period_fin + airpay_prev_fin + 
            (
              (airpay_result1.length * (airpay_result_per + @airpay_inc_per)).round() * airpay_price
            ) rescue 0
          if (airpay_result1_valuation >= airpay_result1_fin) || (Date.today >= @closing_date)
            airpay_result1_fin = airpay_result1_valuation
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
          demaekan_result1_valuation = demaekan_result1.sum(:valuation)
          person_hash["出前館第一成果件数"] = demaekan_result1.length
          person_hash["出前館現状売上"] = demaekan_result1_valuation
          person_hash["出前館一次成果終着"] = demaekan_result1_valuation
        # auステッカー
            au_sticker_user = OtherProduct.where(user_id: user.id).where(product_name: "auPay写真")
            au_sticker_result1 = au_sticker_user.where(date: @start_done.. @end_done)
            au_sticker_result1_valuation = au_sticker_result1.sum(:valuation)
            person_hash["auステッカー第一成果件数"] = au_sticker_result1.length
            person_hash["auステッカー現状売上"] = au_sticker_result1_valuation
            person_hash["auステッカー一次成果終着"] = au_sticker_result1_valuation
        # 現状売上
            # 新規
            valuation_new = 
              person_hash["dメル現状売上1"] + person_hash["PayPay現状売上"] + person_hash["楽天ペイ現状売上"] +
              person_hash["AirPay現状売上"] + person_hash["出前館現状売上"] + person_hash["auステッカー現状売上"]
            person_hash["新規現状売上"] = valuation_new
            # 決済
            valuation_slmt = 
              person_hash["dメル現状売上2"] + person_hash["dメル現状売上3"] + person_hash["auPay現状売上1"]
            person_hash["決済現状売上"] = valuation_slmt
            # 合計
              person_hash["合計現状売上"] = valuation_new + valuation_slmt
        # 終着売上
            # 新規
            valuation_new_fin = 
              person_hash["dメル一次成果終着"] + person_hash["PayPay一次成果終着"] + person_hash["楽天ペイ一次成果終着"] +
              person_hash["AirPay一次成果終着"] + person_hash["出前館一次成果終着"] + person_hash["auステッカー一次成果終着"]
            person_hash["新規終着"] = valuation_new_fin
            # 決済
            valuation_slmt_fin = 
              person_hash["dメル二次成果終着"] + person_hash["dメル三次成果終着"] + person_hash["auPay一次成果終着"]
            person_hash["決済終着"] = valuation_slmt_fin
            # 合計
              person_hash["合計終着"] = valuation_new_fin + valuation_slmt_fin

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
