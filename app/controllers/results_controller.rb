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
      @shifts = Shift.includes(:user).all
      # 個別利益表 
      if @results.group(:user_id).length == 1 
        # dメル　新規
          @dmers_user = Dmer.where(user_id: @results.first.user_id )
          @dmers_this_month = this_period(@dmers_user,@results)
          @dmers_not_this_month = not_period(@dmers_user,@results)
          @dmers_def_this_month = def_period(@dmers_this_month,@results)
          @dmers_inc = inc_period(@dmers_not_this_month,@results)
          @dmers_dec = dec_period(@dmers_not_this_month,@results)
        # dメル　決済
          @dmers_settlementer = Dmer.where(settlementer_id: @results.first.user_id )
          @dmers_slmt_this_month = slmt_this_period(@dmers_settlementer,@results)
          @dmers_slmt_not_this_month = slmt_not_period(@dmers_settlementer,@results)
          @dmers_slmt_def_this_month = slmt_def_period(@dmers_slmt_this_month,@results)
          @dmers_slmt_inc = slmt_inc_period(@dmers_slmt_not_this_month,@results)
          @dmers_slmt_dec = slmt_dec_period(@dmers_slmt_not_this_month,@results)
        # aupay　新規
          @aupays_user = Aupay.where(user_id: @results.first.user_id )
          @aupays_this_month = this_period(@aupays_user,@results)
          @aupays_not_this_month = not_period(@aupays_user,@results)
          @aupays_def_this_month = def_period(@aupays_this_month,@results)
          @aupays_inc = inc_period(@aupays_not_this_month,@results)
          @aupays_dec = dec_period(@aupays_not_this_month,@results)
          # aupay　決済
          @aupays_settlementer = Aupay.where(settlementer_id: @results.first.user_id )
          @aupays_slmt_this_month = slmt_this_period(@aupays_settlementer,@results)
          @aupays_slmt_not_this_month = slmt_not_period(@aupays_settlementer,@results)
          @aupays_slmt_def_this_month = slmt_def_period(@aupays_this_month,@results)
          @aupays_slmt_inc = slmt_inc_period(@aupays_not_this_month,@results)
          @aupays_slmt_dec = slmt_dec_period(@aupays_not_this_month,@results)
        # paypay
            @paypays_user = Paypay.where(user_id: @results.first.user_id )
            @paypays_this_month = this_period(@paypays_user,@results)
            @paypays_def_this_month = def_period(@paypays_this_month,@results)
        # 少額短期保険
          @st_insurances_user = StInsurance.where(user_id: @results.first.user_id )
          @st_insurances_this_month = this_period(@st_insurances_user,@results)
          @st_insurances_def_this_month = def_period(@st_insurances_this_month,@results)
        # 楽天ペイ
          @rakuten_pays_user = RakutenPay.where(user_id: @results.first.user_id )
          @rakuten_pays_this_month = this_period(@rakuten_pays_user,@results)
          @rakuten_pays_not_this_month = not_period(@rakuten_pays_user,@results)
          @rakuten_pays_inc = inc_period(@rakuten_pays_not_this_month,@results)
          @rakuten_pays_dec = dec_period(@rakuten_pays_not_this_month,@results)
          @rakuten_pays_def_this_month = def_period(@rakuten_pays_this_month,@results)
        # 楽天フェムト新規
          @rakuten_casas_user = RakutenCasa.where(user_id: @results.first.user_id)
          @rakuten_casas_this_month = this_period(@rakuten_casas_user, @results)
          @rakuten_casas_def_this_month = def_period(@rakuten_casas_this_month, @results )
          @rakuten_casas_def_net = @rakuten_casas_this_month.where.not(deficiency_net: nil).where(deficiency_solution_net: nil)
          .or(@rakuten_casas_this_month.where.not(deficiency_net: nil).where(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date)))
          @rakuten_casas_def_anti = @rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil)
          .or(@rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date)))
          @rakuten_casas_not_this_month = not_period(@rakuten_casas_user, @results)
          @rakuten_casas_inc = inc_period(@rakuten_casas_not_this_month, @results)
          @rakuten_casas_dec = dec_period(@rakuten_casas_not_this_month, @results)
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
        # グラフパラメーター（訪問）
        @all_store = (@results.sum(:cafe_visit) + @results.sum(:other_food_visit) + @results.sum(:cafe_visit) + @results.sum(:other_retail_visit) + @results.sum(:hair_salon_visit) + @results.sum(:other_service_visit)).to_f
      @chart = [
        ["喫茶・カフェ", (@results.sum(:cafe_visit).to_f / @all_store * 100).round(1) ],
        ["その他飲食", (@results.sum(:other_food_visit).to_f / @all_store * 100).round(1) ],
        ["車屋", (@results.sum(:cafe_visit).to_f / @all_store * 100).round(1) ],
        ["その他小売", (@results.sum(:other_retail_visit).to_f / @all_store * 100).round(1) ],
        ["理容・美容", (@results.sum(:hair_salon_visit).to_f / @all_store * 100).round(1) ],
        ["整体・鍼灸", (@results.sum(:manipulative_visit).to_f / @all_store * 100).round(1) ],
        ["その他サービス", (@results.sum(:other_service_visit).to_f / @all_store * 100).round(1) ],
      ]
      # 切り返し
      @cash_out = @results.includes(:result_cash)
      @cash_out_all = (@results.includes(:result_cash).sum(:out_interview_01) + 
      @cash_out.sum(:out_interview_02) +
      @cash_out.sum(:out_interview_03) +
      @cash_out.sum(:out_interview_04) +
      @cash_out.sum(:out_interview_05) +
      @cash_out.sum(:out_interview_06) +
      @cash_out.sum(:out_interview_07) +
      @cash_out.sum(:out_interview_08) +
      @cash_out.sum(:out_interview_09) +
      @cash_out.sum(:out_interview_10) +
      @cash_out.sum(:out_interview_11) +
      @cash_out.sum(:out_interview_12) +
      @cash_out.sum(:out_interview_13)).to_f
      @cash_out_chart = [
        ["０１：どういうこと？",(@cash_out.includes(:result_cash).sum(:out_interview_01).to_f / @cash_out_all * 100).round(1)],
        ["０２：君は誰？協会？",(@cash_out.includes(:result_cash).sum(:out_interview_02).to_f / @cash_out_all * 100).round(1)],
        ["０３：もらうだけでいいの？",(@cash_out.includes(:result_cash).sum(:out_interview_03).to_f / @cash_out_all * 100).round(1)],
        ["０４：PayPayのみ",(@cash_out.includes(:result_cash).sum(:out_interview_04).to_f / @cash_out_all * 100).round(1)],
        ["０５：AirPayのみ",(@cash_out.includes(:result_cash).sum(:out_interview_05).to_f / @cash_out_all * 100).round(1)],
        ["０６：カードのみ",(@cash_out.includes(:result_cash).sum(:out_interview_06).to_f / @cash_out_all * 100).round(1)],
        ["０７：先延ばし",(@cash_out.includes(:result_cash).sum(:out_interview_07).to_f / @cash_out_all * 100).round(1)],
        ["０８：忙しい",(@cash_out.includes(:result_cash).sum(:out_interview_08).to_f / @cash_out_all * 100).round(1)],
        ["０９：現金のみ",(@cash_out.includes(:result_cash).sum(:out_interview_09).to_f / @cash_out_all * 100).round(1)],
        ["１０：面倒くさい",(@cash_out.includes(:result_cash).sum(:out_interview_10).to_f / @cash_out_all * 100).round(1)],
        ["１１：情報不足",(@cash_out.includes(:result_cash).sum(:out_interview_11).to_f / @cash_out_all * 100).round(1)],
        ["１２：ペロ",(@cash_out.includes(:result_cash).sum(:out_interview_12).to_f / @cash_out_all * 100).round(1)],
        ["１３：その他",(@cash_out.includes(:result_cash).sum(:out_interview_13).to_f / @cash_out_all * 100).round(1)]
      ]
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
      redirect_to results_path
  end


  private
  # dメル,aupayメソッド
    # 新規
    def this_period(product,date)
      return product.where(date: date.minimum(:date)..date.maximum(:date))
    end
    def not_period(product,date)
      return product.where.not(date: date.minimum(:date)..date.maximum(:date))
    end
    def inc_period(product,date)
      return product.where(deficiency_solution: date.minimum(:date)..date.maximum(:date))
    end
    def dec_period(product,date)
      return product.where(deficiency: date.minimum(:date)..date.maximum(:date))
    end
    def def_period(product,date)
      return product.where.not(deficiency: nil).where(deficiency_solution: nil).or(product.where.not(deficiency: nil).where.not(deficiency_solution: date.minimum(:date)..date.maximum(:date)))
    end
    # 決済
    def slmt_this_period(product,date)
      return product.where(settlement: date.minimum(:date)..date.maximum(:date))
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
