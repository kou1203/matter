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
        @shift.where(start_time: @results_date_min..@results_date_min.next_month.ago(1.days))
      @result_shift_min = @result_shift.minimum(:start_time)
      @result_shift_max = @result_shift.maximum(:start_time)

      @new_shift = @result_shift.where(shift: "キャッシュレス新規").length 
      @settlement_shift = @result_shift.where(shift: "キャッシュレス決済").length 
      @summit_shift = @result_shift.where(shift: "サミット").length 
      @casa_shift = @result_shift.where(shift: "楽天フェムト新規").length 
      @casa_put_shift= @result_shift.where(shift: "楽天フェムト設置").length 
      @ojt_shift = @result_shift.where(shift: "帯同").length 
      @house_work_shift = @result_shift.where(shift: "内勤").length
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
      #  dメル
       @dmer_user = 
        Dmer.includes(:store_prop).where(user_id: @results.first.user_id )
        .select(:valuation_new, :industry_status, :user_id, :store_prop_id)
        @dmer_uq = 
        this_period(@dmer_user,@results_date)
        .where(store_prop: {head_store: nil}).select(:valuation_new, :industry_status, :user_id, :store_prop_id)
        @dmer_db = 
        share_period(@dmer_user,@results_date).where.not(store_prop: {head_store: nil})
        .where.not(industry_status: "×").where.not(industry_status: "NG")
        .where(status: "審査OK").select(:valuation_new, :industry_status, :user_id, :store_prop_id)
        @dmer_def = dmer_def(@dmer_uq, @results_date).select(:valuation_new, :industry_status, :user_id, :store_prop_id)
        @dmer_inc = 
        judge_inc(@dmer_user,@results_date).where(store_prop: {head_store: nil})
        .where.not(industry_status: "NG").where.not(industry_status: "×")
        .where(status: "審査OK").select(:valuation_new, :industry_status, :user_id, :store_prop_id)
        @dmer_dec = 
        judge_dec(@dmer_user,@results_date)
        .where.not(industry_status: "NG").where.not(industry_status: "×")
        .select(:valuation_new, :industry_status, :user_id, :store_prop_id)  
        # 決済
        @dmer_slmter = 
          Dmer.where(settlementer_id: @results.first.user_id)
        @dmer_slmt = 
          if @results_date.maximum(:date).day == 25
          slmt_this_period(@dmer_slmter, @results_date)
          .where.not(industry_status: "×")
          .where.not(industry_status: "NG")
          .or(slmt_this_period(@dmer_slmter, @results_date)
          .where(industry_status: nil)).select(:valuation_settlement, :industry_status, :user_id, :store_prop_id)  
        else
        slmt_period(@dmer_slmter, @results_date)
        .where.not(industry_status: "×")
        .where.not(industry_status: "NG")
        .or(slmt_period(@dmer_slmter, @results_date)
        .where(industry_status: nil)).select(:valuation_settlement, :industry_status, :user_id, :store_prop_id)  
        end
        @dmer_slmt2nd_get = 
          slmt2nd_get(@dmer_slmter,@results_date)
          .select(:valuation_second_settlement, :industry_status, :user_id, :store_prop_id)
        @dmer_slmt2nd = 
          slmt_second(@dmer_slmter,@results_date)
          .select(:valuation_second_settlement, :industry_status, :user_id, :store_prop_id)
        # 決済対象 
        @dmers_slmt_target = 
          slmt_dead_line(@dmer_user,@results_date)
          .where.not(industry_status: "NG").where.not(industry_status: "×")
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
        .where(status: "審査通過").select(:valuation_new, :user_id, :store_prop_id)
      @aupay_def =  aupay_def(@aupay_uq,@results_date).select(:valuation_new, :user_id, :store_prop_id)
      @aupay_inc = judge_inc(@aupay_user,@results_date).select(:valuation_new, :user_id, :store_prop_id)
      @aupay_dec = judge_dec(@aupay_user,@results_date).select(:valuation_new, :user_id, :store_prop_id)
      @aupay_slmter = 
        Aupay.where(settlementer_id: @results.first.user_id)
        .select(:settlementer_id, :valuation_settlement)
      @aupay_slmt = 
        if @results_date.maximum(:date).day == 25
        slmt_this_period(@aupay_slmter,@results_date) 
        else
        slmt_period(@aupay_slmter,@results_date) 
        end
      @aupay_slmt_target = slmt_dead_line(@aupay_user, @results_date).select(:valuation_settlement)
      # paypay
      @paypay_user = 
        Paypay.where(user_id: @results.first.user_id)
        .select(:valuation)
      @paypay_data = this_period(@paypay_user ,@results_date).select(:valuation)
      @paypay_result = result_period(@paypay_user ,@results_date)
      # 楽天ペイ
      @rakuten_pay_user = 
        RakutenPay.includes(:store_prop).where(user_id: @results.first.user_id).select(:valuation,:store_prop_id)
      @rakuten_pay_uq =
        this_period(@rakuten_pay_user,@results_date).select(:valuation,:store_prop_id)
      @rakuten_pay_dec = 
        @rakuten_pay_uq.where.not(deficiency: nil)
        .where.not(share: @results_date.minimum(:date)..@results_date.maximum(:date)).select(:valuation,:store_prop_id)
      @rakuten_pay_def =  
        @rakuten_pay_uq.where(status: "自社不備")
        .or(@rakuten_pay_uq.where(status: "自社NG")).select(:valuation,:store_prop_id)
      @rakuten_pay_inc = rakuten_inc(@rakuten_pay_user,@results_date).select(:valuation,:store_prop_id)
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
      return product.where(settlement_second: date.minimum(:date).next_month.beginning_of_month..date.minimum(:date).next_month.end_of_month)
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
