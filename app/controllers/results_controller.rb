class ResultsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @q = Result.includes(:user).ransack(params[:q])
    @results = 
    if params[:q].nil? 
      Result.none 
    else    
      @q.result(distinct: false).order(date: :asc)
    end
      @shifts = Shift.all
      # 個別利益表
      if params[:q].nil?
      else
        # dメル　新規
          @dmers_user = Dmer.where(user_id: @results.first.user_id )
          @dmers_this_month = @dmers_user.where(date: @results.minimum(:date)..@results.maximum(:date))
          @dmers_not_this_month = @dmers_user.where.not(date: @results.minimum(:date)..@results.maximum(:date))
          @dmers_inc = @dmers_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
          @dmers_dec = @dmers_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
          @dmers_def_this_month = @dmers_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@dmers_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
          @dmers_no_def_this_month = @dmers_this_month.where(deficiency: nil).or(@dmers_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
        # dメル　決済
          @dmers_slmt_this_month = @dmers_user.where(settlement: @results.minimum(:date)..@results.maximum(:date))
          @dmers_slmt_not_this_month = @dmers_user.where.not(settlement: @results.minimum(:date)..@results.maximum(:date))
          @dmers_slmt_inc = @dmers_slmt_not_this_month.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date))
          @dmers_slmt_dec = @dmers_slmt_not_this_month.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date))
          @dmers_slmt_def_this_month = @dmers_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@dmers_slmt_this_month.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
          @dmers_slmt_no_def_this_month = @dmers_slmt_this_month.where(deficiency_settlement: nil).or(@dmers_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
        # aupay　新規
          @aupays_user = Aupay.where(user_id: @results.first.user_id )
          @aupays_this_month = @aupays_user.where(date: @results.minimum(:date)..@results.maximum(:date))
          @aupays_not_this_month = @aupays_user.where.not(date: @results.minimum(:date)..@results.maximum(:date))
          @aupays_inc = @aupays_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
          @aupays_dec = @aupays_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
          @aupays_def_this_month = @aupays_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@aupays_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
          @aupays_no_def_this_month = @aupays_this_month.where(deficiency: nil).or(@aupays_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
        # aupay　決済
          @aupays_slmt_this_month = @aupays_user.where(settlement: @results.minimum(:date)..@results.maximum(:date))
          @aupays_slmt_not_this_month = @aupays_user.where.not(settlement: @results.minimum(:date)..@results.maximum(:date))
          @aupays_slmt_inc = @aupays_slmt_not_this_month.where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date))
          @aupays_slmt_dec = @aupays_slmt_not_this_month.where(deficiency_settlement: @results.minimum(:date)..@results.maximum(:date))
          @aupays_slmt_def_this_month = @aupays_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: nil).or(@aupays_slmt_this_month.where.not(deficiency_settlement: nil).where.not(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
          @aupays_slmt_no_def_this_month = @aupays_slmt_this_month.where(deficiency_settlement: nil).or(@aupays_slmt_this_month.where.not(deficiency_settlement: nil).where(deficiency_solution_settlement: @results.minimum(:date)..@results.maximum(:date)))
        # paypay
            @paypays_user = Paypay.where(user_id: @results.first.user_id )
            @paypays_this_month = @paypays_user.where(date: @results.minimum(:date)..@results.maximum(:date))
            @paypays_def_this_month = @paypays_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date)).where(deficiency_solution: nil)
            @paypays_no_def_this_month = @paypays_this_month.where(deficiency: nil).or(@paypays_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
        # 少額短期保険
          @st_insurances_user = StInsurance.where(user_id: @results.first.user_id )
          @st_insurances_this_month = @st_insurances_user.where(date: @results.minimum(:date)..@results.maximum(:date))
          @st_insurances_def_this_month = @st_insurances_user.where(deficiency: @results.minimum(:date)..@results.maximum(:date)).where(deficiency_solution: nil)
          @st_insurances_no_def_this_month = @st_insurances_this_month.where(deficiency: nil).or(@st_insurances_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
        # 楽天ペイ
          @rakuten_pays_user = RakutenPay.where(user_id: @results.first.user_id )
          @rakuten_pays_this_month = @rakuten_pays_user.where(date: @results.minimum(:date)..@results.maximum(:date))
          @rakuten_pays_not_this_month = @rakuten_pays_user.where.not(date: @results.minimum(:date)..@results.maximum(:date))
          @rakuten_pays_inc = @rakuten_pays_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
          @rakuten_pays_dec = @rakuten_pays_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))
          @rakuten_pays_def_this_month = @rakuten_pays_this_month.where.not(deficiency: nil).where(deficiency_solution: nil)
          @rakuten_pays_no_def_this_month = @rakuten_pays_this_month.where(deficiency: nil).or(@rakuten_pays_this_month.where.not(deficiency: nil).where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date)))
        # 楽天フェムト新規
          @rakuten_casas_user = RakutenCasa.where(user_id: @results.first.user_id)
          @rakuten_casas_this_month = @rakuten_casas_user.where(date: @results.minimum(:date)..@results.maximum(:date))
          @rakuten_casas_not_this_month = @rakuten_casas_user.where.not(date: @results.minimum(:date)..@results.maximum(:date))
          @rakuten_casas_inc = @rakuten_casas_not_this_month.where(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))
          @rakuten_casas_dec = @rakuten_casas_not_this_month.where(deficiency: @results.minimum(:date)..@results.maximum(:date))

          @rakuten_casas_def_this_month = @rakuten_casas_this_month.where.not(deficiency: nil).where(deficiency_solution: nil).or(@rakuten_casas_this_month.where.not(deficiency: nil).where.not(deficiency_solution: @results.minimum(:date)..@results.maximum(:date))).or(@rakuten_casas_this_month.where.not(deficiency_net: nil).where(deficiency_solution_net: nil)).or(@rakuten_casas_this_month.where.not(deficiency_net: nil).where.not(deficiency_solution_net: @results.minimum(:date)..@results.maximum(:date))).or(@rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: nil)).or(@rakuten_casas_this_month.where.not(deficiency_anti: nil).where(deficiency_solution_anti: @results.minimum(:date)..@results.maximum(:date)))
        # 楽天フェムト設置
          @rakuten_casas_put = @rakuten_casas_user.where(put: @results.minimum(:date)..@results.maximum(:date))
          # 設置
          @rakuten_casas_put_self = @rakuten_casas_put.where(putter_id: @results.first.user_id)
          # 他者設置
          @rakuten_casas_put_other = RakutenCasa.where.not(user_id: @results.first.user_id).where(putter_id: @rakuten_casas_user).where(put: @results.minimum(:date)..@results.maximum(:date))
          # 設置依頼
          @rakuten_casas_put_request = @rakuten_casas_put.where.not(putter_id: @results.first.user_id)
      end
      # グラフパラメーター
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
