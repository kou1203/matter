class ResultsController < ApplicationController

  def index 
    @q = Result.ransack(params[:q])
    @results = 
      if params[:q].nil? 
        Result.none 
      else    
        @q.result(distinct: false)
      end
    @shifts = Shift.all
    @summits = Summit.all

    @result_month = Result.where(date: Time.now.beginning_of_month..Time.now.end_of_month)
    @result_week1 = Result.where(date: Time.now.beginning_of_month..Time.now.beginning_of_month.next_week(:monday))
    @result_week2 = Result.where(date: Time.now.beginning_of_month.next_week(:tuesday)..Time.now.beginning_of_month.next_week(:monday).since(7.days))
    @result_week3 = Result.where(date: Time.now.beginning_of_month.next_week(:tuesday).since(7.days)..Time.now.beginning_of_month.next_week(:monday).since(14.days))
    @result_week4 = Result.where(date: Time.now.beginning_of_month.next_week(:tuesday).since(14.days)..Time.now.end_of_month)
    @result_before_month = Result.where(date: Time.now.months_ago(1).beginning_of_month..Time.now.months_ago(1).end_of_month)

    @chubu_group = Result.includes(:user).where(users: {base: "中部SS"}).where(date: Time.now.beginning_of_month..Time.now.end_of_month)
    @chubu_cash = @chubu_group.where(shift: "キャッシュレス新規")
    
    @kansai_group = Result.includes(:user).where(users: {base: "関西SS"}).where(date: Time.now.beginning_of_month..Time.now.end_of_month)
    @kansai_cash = @kansai_group.where(shift: "キャッシュレス新規")
    
    @tokyo_group = Result.includes(:user).where(users: {base: "東京SS"}).where(date: Time.now.beginning_of_month..Time.now.end_of_month)
    @tokyo_cash = @tokyo_group.where(shift: "キャッシュレス新規").or(@tokyo_group.where(shift: "パンダ"))

  end 

  def new 
    @users = User.where.not(base: "退職")
    @result = Result.new 
  end 
  
  def create 
    @users = User.where.not(base: "退職")
    @result = Result.new(result_params)
    if @result.save 
      redirect_to store_props_path 
    else  
      render :new 
    end
  end

  def import 
    Result.import(params[:file])
    redirect_to summits_path
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
      :ojt, 
      :dmer,                    
      :dmer_settlement,         
      :aupay,
      :paypay,
      :aupay_settlement,
      :panda,
      :praness,
      :summit,
      :first_visit,
      :first_interview,
      :first_full_talk, 
      :first_get,        
      :latter_visit,     
      :latter_interview, 
      :latter_full_talk, 
      :latter_get,       
      :cafe_visit,          
      :cafe_interview,      
      :cafe_full_talk,     
      :cafe_get,            
      :other_food_visit,          
      :other_food_interview,      
      :other_food_full_talk,      
      :other_food_get       ,     
      :car_visit          ,
      :car_interview      ,
      :car_full_talk      ,
      :car_get            ,
      :other_retail_visit  ,        
      :other_retail_interview     , 
      :other_retail_full_talk      ,
      :other_retail_get            ,
      :hair_salon_visit          ,
      :hair_salon_interview      ,
      :hair_salon_full_talk      ,
      :hair_salon_get            ,
      :manipulative_visit         , 
      :manipulative_interview      ,
      :manipulative_full_talk      ,
      :manipulative_get            ,
      :other_service_visit          ,
      :other_service_interview      ,
      :other_service_full_talk      ,
      :other_service_get    ,
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
      :summit_ng_detail,
      :summit_ng_cash,
      :summit_ng_building,
      :summit_reject_cash_interview,      
      :summit_reject_cash_full_talk ,     
      :summit_reject_cash_get  ,
      :summit_doubt_interview   ,   
      :summit_doubt_full_talk    ,  
      :summit_doubt_get  ,
      :summit_busy_interview   ,   
      :summit_busy_full_talk    ,  
      :summit_busy_get  ,
      :summit_yet_interview ,     
      :summit_yet_full_talk  ,    
      :summit_yet_get  ,
      :summit_not_change_interview   ,   
      :summit_not_change_full_talk    ,  
      :summit_not_change_get  ,
      :summit_other_interview  ,    
      :summit_other_full_talk   ,   
      :summit_other_get  ,
      :summit_easy_interview  ,    
      :summit_easy_full_talk   ,   
      :summit_easy_get  , 
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
      :panda_easy_get 
    )
  end 
end
