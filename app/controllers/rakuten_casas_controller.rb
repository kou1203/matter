class RakutenCasasController < ApplicationController

  def index 
    @q = RakutenCasa.ransack(params[:q])
    @rakuten_casas = 
      if params[:q].nil?
        RakutenCasa.none 
      else  
        @q.result(distinct: true)
      end
  end 

  def new 
    @rakuten_casa = RakutenCasa.new 
    @store_prop = StoreProp.find(params[:store_prop_id])
  end 
  
  def create 
    @rakuten_casa = RakutenCasa.new(rakuten_casa_params)
    @store_prop = StoreProp.find(params[:store_prop_id])
    if @rakuten_casa.save 
      redirect_to rakuten_casas_path 
    else  
      render :new 
    end
  end 

  def import 
    RakutenCasa.import(params[:file])
    redirect_to rakuten_casas_path
  end 

  def show 
    @rakuten_casa = RakutenCasa.find(params[:id])
  end

  def edit 
    @rakuten_casa = RakutenCasa.find(params[:id])
  end 
  
  def update 
    @rakuten_casa = RakutenCasa.find(params[:id])
    @rakuten_casa.update(rakuten_casa_params)
    redirect_to rakuten_casas_path
  end 

  private 
  def rakuten_casa_params 
    params.require(:rakuten_casa).permit(
      :client              ,
      :store_prop_id       ,          
      :user_id             ,                
      :date                ,         
      :contract_type       ,      
      :contracter          ,       
      :line_type           ,       
      :confirm_method      ,       
      :hikari_collabo      ,       
      :line_service        ,       
      :customer_num        ,       
      :femto_id            ,        
      :status              ,       
      :error_status        ,             
      :error_confirmer     ,                
      :remarks             ,
      :payment             ,
      :get_profit    ,
      :put_profit       
    )
  end 


end
