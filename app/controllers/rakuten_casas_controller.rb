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
      :client                  ,
      :user_id                 ,                
      :store_prop_id           ,          
      :date                    ,         
      :status                  ,       
      :status_update           ,       
      :net_confirm_method      ,       
      :net_name                ,      
      :hikari_collabo          ,       
      :net_plan                ,       
      :customer_num            ,       
      :net_contracter          ,       
      :net_contracter_kana     ,       
      :net_phone_number        ,
      # 不備       
      :error_status            ,             
      :error_solution          ,                
      # 設置
      :putter_id               ,
      :status_put              ,
      :status_update_put       ,
      :put                     ,
      :put_deadline            ,
      :payment                 ,
      :payment_put             ,
      :profit_new              ,
      :profit_put              , 
      :valuation_new           , 
      :valuation_put           , 
      :description_error       ,
      :description             ,
      :vendor_material_code    ,
      :serial_number           ,
      :delivery_date           ,
      :inspection              ,
      :femto_id                ,         
      )
    end 
    
    
  end
  