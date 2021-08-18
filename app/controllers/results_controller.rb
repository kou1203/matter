class ResultsController < ApplicationController

  def index 
    @q = Result.ransack(params[:q])
    @results = 
      if params[:q].nil? 
        Result.none 
      else    
        @q.result(distinct: false).order(date: :asc)
      end
      @shifts = Shift.all
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

    @users = User.where.not(base: "中部N").where.not(base: "関西N").where.not(base: "退職").where.not(base: "")
  end 

  def new 
    @users = User.where.not(base: "退職")
    @result = Result.new 
  end 
  
  def create 
    @users = User.where.not(base: "退職")
    @result = Result.new(result_params)
    if @result.save 
      redirect_to results_path 
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
    # 商材
      :dmer,                    
      :dmer_settlement,         
      :aupay,
      :aupay_settlement,
      :paypay,
      :panda,
      :praness,
      :summit_metered_lamp,
      :summit_power,
      :rakuten_casa,
      :rakuten_casa_put,
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
    # キャッシュレス
      :cashless_what_interview      ,
      :cashless_what_full_talk      ,
      :cashless_what_get            ,
      :cashless_who_interview      ,
      :cashless_who_full_talk      ,
      :cashless_who_get            ,
      :cashless_just_get_interview  ,    
      :cashless_just_get_full_talk   ,   
      :cashless_just_get_get          ,  
      :cashless_paypay_only_interview  ,    
      :cashless_paypay_only_full_talk   ,   
      :cashless_paypay_only_get          ,  
      :cashless_airpay_only_interview     , 
      :cashless_airpay_only_full_talk      ,
      :cashless_airpay_only_get            ,
      :cashless_card_only_interview      ,
      :cashless_card_only_full_talk      ,
      :cashless_card_only_get            ,
      :cashless_yet_interview      ,
      :cashless_yet_full_talk      ,
      :cashless_yet_get            ,
      :cashless_cash_only_interview ,     
      :cashless_cash_only_full_talk  ,    
      :cashless_cash_only_get         ,   
      :cashless_busy_interview      ,
      :cashless_busy_full_talk      ,
      :cashless_busy_get            ,
      :cashless_dull_interview      ,
      :cashless_dull_full_talk      ,
      :cashless_dull_get            ,
      :cashless_lack_info_interview  ,    
      :cashless_lack_info_full_talk   ,   
      :cashless_lack_info_get          ,  
      :cashless_easy_interview      ,
      :cashless_easy_full_talk      ,
      :cashless_easy_get   ,
      :cashless_other_interview      ,
      :cashless_other_full_talk      ,
      :cashless_other_get,
    # サミット
      # NG
      :summit_no_detail,
      :summit_ng_detail,
      # 引き落とし拒否
      :summit_reject_cash_interview,      
      :summit_reject_cash_full_talk ,     
      :summit_reject_cash_get  ,
      # 忙しい
      :summit_busy_interview   ,   
      :summit_busy_full_talk    ,  
      :summit_busy_get  ,
      # 怪しい
      :summit_doubt_interview   ,   
      :summit_doubt_full_talk    ,  
      :summit_doubt_get  ,
      # 検討
      :summit_yet_interview ,     
      :summit_yet_full_talk  ,    
      :summit_yet_get  ,
      # 変えたくない
      :summit_not_change_interview   ,   
      :summit_not_change_full_talk    ,  
      :summit_not_change_get  ,
      # 情報不足
      :summit_lack_info_interview,
      :summit_lack_info_full_talk,
      :summit_lack_info_get,
      # その他
      :summit_other_interview  ,    
      :summit_other_full_talk   ,   
      :summit_other_get  ,
      # ぺろ
      :summit_easy_interview  ,    
      :summit_easy_full_talk   ,   
      :summit_easy_get  , 
    # パンダ
      :panda_not_need_interview,      
      :panda_not_need_full_talk,      
      :panda_not_need_get, 
      :panda_busy_interview,      
      :panda_busy_full_talk,      
      :panda_busy_get, 
      :panda_yet_interview,      
      :panda_yet_full_talk,      
      :panda_yet_get, 
      :panda_not_delivery_interview,      
      :panda_not_delivery_full_talk,      
      :panda_not_delivery_get, 
      :panda_not_increment_interview,      
      :panda_not_increment_full_talk,      
      :panda_not_increment_get, 
      :panda_not_margin_interview,      
      :panda_not_margin_full_talk,      
      :panda_not_margin_get, 
      :panda_dull_interview,      
      :panda_dull_full_talk,      
      :panda_dull_get, 
      :panda_lack_info_interview,      
      :panda_lack_info_full_talk,     
      :panda_lack_info_get,
      :panda_food_neko_interview,      
      :panda_food_neko_full_talk,     
      :panda_food_neko_get,
      :panda_other_interview,      
      :panda_other_full_talk,      
      :panda_other_get, 
      :panda_easy_interview,      
      :panda_easy_full_talk,      
      :panda_easy_get,
    # 楽天カーサ
      :casa_ng_lack_info,
      :casa_busy_interview,
      :casa_busy_full_talk,
      :casa_busy_get,
      :casa_dull_interview,
      :casa_dull_full_talk,
      :casa_dull_get,
      :casa_not_put_space_interview,
      :casa_not_put_space_full_talk,
      :casa_not_put_space_get,
      :casa_no_merit_interview,
      :casa_no_merit_full_talk,
      :casa_no_merit_get,
      :casa_distrust_interview,
      :casa_distrust_full_talk,
      :casa_distrust_get,
      :casa_not_use_net_interview,
      :casa_not_use_net_full_talk,
      :casa_not_use_net_get,
      :casa_not_need_interview,
      :casa_not_need_full_talk,
      :casa_not_need_get,
      :casa_easy_interview,
      :casa_easy_full_talk,
      :casa_easy_get,
      :casa_other_interview,
      :casa_other_full_talk,
      :casa_other_get
    )
  end 
end
