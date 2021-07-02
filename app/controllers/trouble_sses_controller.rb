class TroubleSsesController < ApplicationController

  def index 
    @q = TroubleSs.ransack(params[:q])
    @trouble_sses = 
      if params[:q].nil? 
        TroubleSs.none 
      else  
        @q.result(distinct: false)
      end 
  end 

  def new 
    @trouble_ss = TroubleSs.new
    @users = User.all
    @store_prop = StoreProp.find(params[:store_prop_id])
  end 
  
  def create 
    @users = User.all
    @store_prop = StoreProp.find(params[:store_prop_id])
    @trouble_ss = TroubleSs.new(trouble_ss_params)
    if @trouble_ss.save 
      redirect_to trouble_sses_path
    else  
      render :new 
    end
  end 

  def import 
  end 

  def edit 
    @users = User.all
    @trouble_ss = TroubleSs.find(params[:id])
  end 
  
  def update 
    @users = User.all
    @trouble_ss = TroubleSs.find(params[:id])
    @trouble_ss.update(trouble_ss_params)
    redirect_to store_prop_path(@trouble_ss.store_prop.id)
    
  end 

  private
  def trouble_ss_params 
    params.require(:trouble_ss).permit(
      :date             , 
      :store_prop_id    , 
      :category         , 
      :customer_name    , 
      :get_status       , 
      :product          , 
      :user_id          ,
      :confirmer        , 
      :content_type     ,
      :customer_opinion ,
      :contact_date     ,
      :result           ,
      :remarks           
    )
  end 
end
