class ResultRakutenCasasController < ApplicationController


  def index 
  end 

  def new 
    @result_rakuten_casa = ResultRakutenCasa.new 
    @result = Result.find(params[:result_id])
  end 
  
  def create 
    @result_rakuten_casa = ResultRakutenCasa.new(result_rakuten_casa_params)
    
    if @result_rakuten_casa.save 
     redirect_to result_rakuten_casas_path
    else  
      render :new 
    end 
  end 

  def edit 
  end 

  def update 
  end 

  private 
  def result_rakuten_casa_params
    params.require(:result_rakuten_casa).permit(
    # 楽天カーサ
      :result_id,
      :ng_lack_info,
      :busy_interview,
      :busy_full_talk,
      :busy_get,
      :dull_interview,
      :dull_full_talk,
      :dull_get,
      :not_put_space_interview,
      :not_put_space_full_talk,
      :not_put_space_get,
      :no_merit_interview,
      :no_merit_full_talk,
      :no_merit_get,
      :distrust_interview,
      :distrust_full_talk,
      :distrust_get,
      :not_use_net_interview,
      :not_use_net_full_talk,
      :not_use_net_get,
      :not_need_interview,
      :not_need_full_talk,
      :not_need_get,
      :easy_interview,
      :easy_full_talk,
      :easy_get,
      :other_interview,
      :other_full_talk,
      :other_get
    )
  end 
end
