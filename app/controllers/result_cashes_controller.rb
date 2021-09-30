class ResultCashesController < ApplicationController

  def index 
    @q = Result.includes(:user).includes(:result_cash).ransack(params[:q])
    @results = 
      if params[:q].nil? 
        Result.none 
      else    
        @q.result(distinct: false).order(date: :asc)
      end
  end 

  def new 
    @result_cash = ResultCash.new 
    @result = Result.find(params[:result_id])
  end 
  
  def create 
    @result_cash = ResultCash.new(result_cash_params)
    if @result_cash.save 
     redirect_to result_cashes_path
    else  
      render :new 
    end 
  end 

  def edit 
  end 

  def update 
  end 

  private 
  def result_cash_params
    params.require(:result_cash).permit(
      # どういうこと？
      :result_id,
      :what_interview      ,
      :what_full_talk      ,
      :what_get            ,
      # 君は誰？
      :who_interview      ,
      :who_full_talk      ,
      :who_get            ,
      # もらうだけ？
      :just_get_interview,      
      :just_get_full_talk ,     
      :just_get_get        ,    
      # PayPayのみ
      :paypay_only_interview,      
      :paypay_only_full_talk ,     
      :paypay_only_get        ,    
      # エアペイのみ
      :airpay_only_interview      ,
      :airpay_only_full_talk      ,
      :airpay_only_get      ,
      # カードのみ      
      :card_only_interview   ,   
      :card_only_full_talk    ,  
      :card_only_get           ,
      # 先延ばし 
      :yet_interview      ,
      :yet_full_talk      ,
      :yet_get       ,
      # 現金のみ     
      :cash_only_interview   ,   
      :cash_only_full_talk    ,  
      :cash_only_get           ,
      # 忙しい 
      :busy_interview      ,
      :busy_full_talk      ,
      :busy_get    ,
      # めんどくさい        
      :dull_interview,      
      :dull_full_talk ,     
      :dull_get        ,    
      # 情報不足
      :lack_info_interview  ,    
      :lack_info_full_talk   ,   
      :lack_info_get          ,  
      # ぺろ
      :easy_interview      ,
      :easy_full_talk      ,
      :easy_get   ,
      # その他
      :other_interview ,     
      :other_full_talk  ,    
      :other_get    
    )
  end 
end
