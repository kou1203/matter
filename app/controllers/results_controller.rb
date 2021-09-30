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
      # 商材
      @dmers = Dmer.all 
      @aupays = Aupay.all 
      @paypays = Paypay.all 
      @rakuten_pays = RakutenPay.all
      @st_insurances = StInsurance.all
      @summits = Summit.all
      @costs = Cost.all 
      
      @result_month = Result.includes(:user).where(date: Time.now.beginning_of_month..Time.now.end_of_month)
      @shift_month = Shift.includes(:user).where(year: Date.today.year).where(month: Date.today.month)

    @result_week1 = Result.where(date: Time.now.beginning_of_month..Time.now.beginning_of_month.next_week(:monday))
    @result_week2 = Result.where(date: Time.now.beginning_of_month.next_week(:tuesday)..Time.now.beginning_of_month.next_week(:monday).since(7.days))
    @result_week3 = Result.where(date: Time.now.beginning_of_month.next_week(:tuesday).since(7.days)..Time.now.beginning_of_month.next_week(:monday).since(14.days))
    @result_week4 = Result.where(date: Time.now.beginning_of_month.next_week(:tuesday).since(14.days)..Time.now.end_of_month)
    @result_before_month = Result.where(date: Time.now.months_ago(1).beginning_of_month..Time.now.months_ago(1).end_of_month)

    @chubu_group = Result.includes(:user).where(users: {base: "中部SS"}).where(date: Time.now.beginning_of_month..Time.now.end_of_month)
    @chubu_cash = @chubu_group.where(shift: "キャッシュレス新規")
    
    @kansai_group = Result.includes(:user).where(users: {base: "関西SS"}).where(date: Time.now.beginning_of_month..Time.now.end_of_month)
    @kansai_cash = @kansai_group.where(shift: "キャッシュレス新規")
    
    @tokyo_group = Result.includes(:user).where(users: {base: "関東SS"}).where(date: Time.now.beginning_of_month..Time.now.end_of_month)
    @tokyo_cash = @tokyo_group.where(shift: "キャッシュレス新規").or(@tokyo_group.where(shift: "パンダ"))

    @users = User.where.not(base: "中部N").where.not(base: "関西N").where.not(position: "退職").where.not(base: "")
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
        redirect_to  result_result_rakuten_casas_new_path(@result.id)
      else  
        redirect_to results_path
      end  
    else  
      render :new 
    end
  end

  def import 
    Result.import(params[:file])
    redirect_to results_path
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
    # # サミット
    #   # NG
    #   :summit_no_detail,
    #   :summit_ng_detail,
    #   # 引き落とし拒否
    #   :summit_reject_cash_interview,      
    #   :summit_reject_cash_full_talk ,     
    #   :summit_reject_cash_get  ,
    #   # 忙しい
    #   :summit_busy_interview   ,   
    #   :summit_busy_full_talk    ,  
    #   :summit_busy_get  ,
    #   # 怪しい
    #   :summit_doubt_interview   ,   
    #   :summit_doubt_full_talk    ,  
    #   :summit_doubt_get  ,
    #   # 検討
    #   :summit_yet_interview ,     
    #   :summit_yet_full_talk  ,    
    #   :summit_yet_get  ,
    #   # 変えたくない
    #   :summit_not_change_interview   ,   
    #   :summit_not_change_full_talk    ,  
    #   :summit_not_change_get  ,
    #   # 情報不足
    #   :summit_lack_info_interview,
    #   :summit_lack_info_full_talk,
    #   :summit_lack_info_get,
    #   # その他
    #   :summit_other_interview  ,    
    #   :summit_other_full_talk   ,   
    #   :summit_other_get  ,
    #   # ぺろ
    #   :summit_easy_interview  ,    
    #   :summit_easy_full_talk   ,   
    #   :summit_easy_get  , 
    # # パンダ
    #   :panda_not_need_interview,      
    #   :panda_not_need_full_talk,      
    #   :panda_not_need_get, 
    #   :panda_busy_interview,      
    #   :panda_busy_full_talk,      
    #   :panda_busy_get, 
    #   :panda_yet_interview,      
    #   :panda_yet_full_talk,      
    #   :panda_yet_get, 
    #   :panda_not_delivery_interview,      
    #   :panda_not_delivery_full_talk,      
    #   :panda_not_delivery_get, 
    #   :panda_not_increment_interview,      
    #   :panda_not_increment_full_talk,      
    #   :panda_not_increment_get, 
    #   :panda_not_margin_interview,      
    #   :panda_not_margin_full_talk,      
    #   :panda_not_margin_get, 
    #   :panda_dull_interview,      
    #   :panda_dull_full_talk,      
    #   :panda_dull_get, 
    #   :panda_lack_info_interview,      
    #   :panda_lack_info_full_talk,     
    #   :panda_lack_info_get,
    #   :panda_food_neko_interview,      
    #   :panda_food_neko_full_talk,     
    #   :panda_food_neko_get,
    #   :panda_other_interview,      
    #   :panda_other_full_talk,      
    #   :panda_other_get, 
    #   :panda_easy_interview,      
    #   :panda_easy_full_talk,      
    #   :panda_easy_get,
    )
  end 
end
