class StorePropsController < ApplicationController

  def index 
    @q = StoreProp.ransack(params[:q])
    @store_props = 
      if params[:q].nil?
        StoreProp.none 
      else
        @q.result(distinct: true)
      end
    
  end 

  def new 
    @store_prop = StoreProp.new
  end 

  def create 
    @store_prop = StoreProp.new(store_prop_params)
    if @store_prop.save
      redirect_to store_prop_path(@store_prop.id)
    else 
      render :new
    end

  end 

  def edit 
    @store_prop = StoreProp.find(params[:id])
  end 
  
  def update 
    @store_prop = StoreProp.find(params[:id])
    @store_prop.update(store_prop_params)
    redirect_to store_prop_path(@store_prop.id)
  end 

  def import 
    StoreProp.import(params[:file]) 
    redirect_to store_props_path
  end 

  def show 
    @store_prop = StoreProp.find(params[:id])
    @dmer = @store_prop.dmer
    @aupay = @store_prop.aupay
    @paypay = @store_prop.paypay
    @praness = @store_prop.praness
    @rakuten_casa = @store_prop.rakuten_casa
    @summit_customer_prop = @store_prop.summit_customer_prop
    if @summit_customer_prop.nil?
      @summits = 0
    else  
      @summits = @summit_customer_prop.summits
    end

    @panda = @store_prop.pandas 
  end

  private 

  def store_prop_params
    params.require(:store_prop).permit(
      :race,
      :name,
      :corporate_name,
      :industry,
      :description, 
      :phone_number_1,
      :phone_number_2, 
      :person_main, 
      :person_main_kana,
      :birthday, 
      :person_sub, 
      :person_sub_kana, 
      :mail_1,
      :mail_2,
      :prefecture, 
      :city, 
      :municipalities,
      :address, 
      :building_name, 
      :suitable_time, 
      :holiday,
      :head_store 
    )
  end 

end
