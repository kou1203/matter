class StorePropsController < ApplicationController

  def index 
    @store_props = StoreProp.all
  end 

  def new 
    @store_prop = StoreProp.new
  end 

  def create 
    @store_prop = StoreProp.new(store_prop_params)
    if @store_prop.save
      redirect_to root_path 
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
    redirect_to stocks_path
  end 

  def show 
    @store_prop = StoreProp.find(params[:id])
    @dmer = @store_prop.dmer
    @praness = @store_prop.praness
  end

  private 

  def store_prop_params
    params.require(:store_prop).permit(
      :race, :name, :suitable_time, :description, :industry,
      :phone_number_1, :phone_number_2, :person_main,
      :person_sub, :prefectures, :city, :municipalities,
      :address, :building_name
    )
  end 

end
