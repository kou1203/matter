class ResultsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @q = Result.ransack(params[:q])
    @results = 
    if params[:q].nil? 
      Result.none 
    else    
      @q.result(distinct: false).includes(:user).order(date: :asc)
    end
    @month = params[:month] ? Date.parse(params[:month]) : @results.minimum(:date)
      @shifts = Shift.includes(:user).all
      # 個別利益表 
      if @results.group(:user_id).length == 1 
        # dメル　新規
          @dmers_user = Dmer.where(user_id: @results.first.user_id )
          @dmers_this_month = this_period(@dmers_user,@results)
          @dmers_def_this_month = this_period(@dmers_this_month.where(status: "自社不備")
          .or(@dmers_this_month.where(status: "審査NG"))
          .or(@dmers_this_month.where(status: "不備対応中"))
          .or(@dmers_this_month.where(status: "申込取消"))
          .or(@dmers_this_month.where(status: "申込取消（不備）"))
          .or(@dmers_this_month.where(status: "審査OK").where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))),@results)
          @dmers_inc = inc_period(@dmers_this_month,@results)
          
        # dメル　決済
          @dmers_settlementer = Dmer.where(settlementer_id: @results.first.user_id )
          @dmers_slmt_this_month = slmt_this_period(@dmers_settlementer,@results)
          @dmers_slmt_not_this_month = slmt_not_period(@dmers_settlementer,@results)
          @dmers_slmt_def_this_month = slmt_def_period(@dmers_slmt_this_month,@results)
          @dmers_slmt_inc = slmt_inc_period(@dmers_slmt_not_this_month,@results)
          @dmers_slmt_dec = slmt_dec_period(@dmers_slmt_not_this_month,@results)
          @dmers_slmt_def = slmt_this_period(@dmers_settlementer.where(status_settlement: "未決済"),@results)
          @dmers_slmt_def_pic = slmt_this_period(@dmers_settlementer.where(status_settlement: "写真不備"),@results)
          # 決済対象
          @dmers_slmt_target = slmt_dead_line(@dmers_user,@results)

        # aupay　新規
          @aupays_user = Aupay.where(user_id: @results.first.user_id )
          @aupays_this_month = this_period(@aupays_user,@results)
          @aupays_not_this_month = not_period(@aupays_user,@results)
          @aupays_def_this_month = this_period(@aupays_this_month.where(status: "自社不備")
          .or(@aupays_this_month.where(status: "不合格"))
          .or(@aupays_this_month.where(status: "差し戻し"))
          .or(@aupays_this_month.where(status: "解約"))
          .or(@aupays_this_month.where(status: "重複対象外"))
          .or(@aupays_this_month.where(status: "審査通過").where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))),@results)
          @aupays_inc = inc_period(@aupays_not_this_month,@results)
          # aupay　決済
          @aupays_settlementer = Aupay.where(settlementer_id: @results.first.user_id )
          @aupays_slmt_this_month = slmt_this_period(@aupays_settlementer,@results)
          @aupays_slmt_not_this_month = slmt_not_period(@aupays_settlementer,@results)
          @aupays_slmt_def_this_month = slmt_def_period(@aupays_this_month,@results)
          @aupays_slmt_inc = slmt_inc_period(@aupays_not_this_month,@results)

          @aupays_slmt_target = slmt_dead_line(@aupays_user,@results)
          # 決済の合計
          @slmt_sum = @dmers_slmt_target.sum(:valuation_settlement) + @aupays_slmt_target.sum(:valuation_settlement)
        # paypay
            @paypays_user = Paypay.where(user_id: @results.first.user_id )
            @paypays_this_month = this_period(@paypays_user,@results)
            @paypays_def_this_month = @paypays_this_month.where(status: "自社不備")
        # 少額短期保険
          @st_insurances_user = StInsurance.where(user_id: @results.first.user_id )
          @st_insurances_this_month = this_period(@st_insurances_user,@results)
          @st_insurances_def_this_month = this_period(@st_insurances_this_month,@results)
        # 楽天ペイ
          @rakuten_pays_user = RakutenPay.where(user_id: @results.first.user_id )
          @rakuten_pays_this_month = this_period(@rakuten_pays_user,@results)
          @rakuten_pays_not_this_month = not_period(@rakuten_pays_user,@results)
          @rakuten_pays_inc = inc_period(@rakuten_pays_not_this_month,@results)
          @rakuten_pays_def_this_month = @rakuten_pays_this_month.where(status: "自社不備")
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
      else
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

  def show 
    @result = Result.find(params[:id])
    @q = Result.ransack(params[:q])
    @results = 
    if params[:q].nil? 
      Result.none 
    else    
      @q.result(distinct: false)
    end

  end 

  def edit 
    @result = Result.find(params[:id])
  end 
  
  def update 
    @result = Result.find(params[:id])
    @result.update(result_params)
    if @result.shift == "キャッシュレス新規" && @result.result_cash.nil?
      redirect_to  result_result_cashes_new_path(@result.id)
    elsif @result.shift == "キャッシュレス新規"
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
      redirect_to results_path
    end
  end


  private
  # dメル,aupayメソッド
    # 新規
    # 絞り込んだ期間のもの
    def this_period(product,date)
      return product.where(date: date.minimum(:date)..date.maximum(:date))
    end
    def not_period(product,date)
      return product.where.not(date: date.minimum(:date)..date.maximum(:date))
    end
    # 絞り込んだ期間ではなく、不備解消が絞り込んだ期間のもの
    def inc_period(product,date)
      return product.where.not(date: date.minimum(:date)..date.maximum(:date)).where(deficiency_solution: date.minimum(:date)..date.maximum(:date))
    end

    # 決済
    def slmt_this_period(product,date)
      return product.where(settlement: date.minimum(:date)..date.maximum(:date)).where(status_settlement: "完了")
    end
    
    def slmt_def(product,date)
      return product.where(settlement: date.minimum(:date)..date.maximum(:date)).where(status_settlement: "未決済")
    end
    def slmt_pic(product,date)
      return product.where(settlement: date.minimum(:date)..date.maximum(:date)).where(status_settlement: "写真不備")
    end

    def slmt_not_period(product,date)
      return product.where.not(settlement: date.minimum(:date)..date.maximum(:date))
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
      return product.where(settlement_deadline: date.minimum(:date)..date.minimum(:date).since(3.month).end_of_month).where(status: "審査OK").where(settlement: nil)
      .or(product.where(settlement_deadline: date.minimum(:date)..date.minimum(:date).since(3.month).end_of_month).where(status: "審査OK").where(settlement: date.minimum(:date)..date.maximum(:date)))
      .or(product.where(settlement_deadline: date.minimum(:date)..date.minimum(:date).since(3.month).end_of_month).where(status: "審査通過").where(settlement: nil))
      .or(product.where(settlement_deadline: date.minimum(:date)..date.minimum(:date).since(3.month).end_of_month).where(status: "審査通過").where(settlement: date.minimum(:date)..date.maximum(:date)))
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
      :profit,
      :area,
      :shift,
      :ojt_id, 
    # 基準値
      # 前半
      :first_visit,
      :first_interview,
      :first_full_talk, 
      :first_get,       
      # 後半 
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
    )
  end 
end
