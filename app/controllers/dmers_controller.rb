class DmersController < ApplicationController

  def index 
    @q = Dmer.ransack(params[:q])
    @dmers = @q.result(distinct: true)
  end 

  def new 
    @dmer = Dmer.new
    @users = User.where(retiree: nil)
    @store_prop = StoreProp.find(params[:store_prop_id])
  end 
  
  def create 
    @dmer = Dmer.new(dmer_params)
    @users = User.where(retiree: nil)
    @store_prop = StoreProp.find(params[:store_prop_id])
    @dmer.save 
    if @dmer.save 
      redirect_to store_props_path(@store_prop.id)
    else  
      render :new 
    end 
  end 

  def show 
    @dmer = Dmer.find(params[:id])
    @users = User.all
  end 

  def edit 
    @dmer = Dmer.find(params[:id])
    @users = User.where(retiree: nil)
  end 
  
  def update 
    @dmer = Dmer.find(params[:id])
    @dmer.update(dmer_params)
    redirect_to dmers_path
  end 

  def import 
    Dmer.import(params[:file])
    redirect_to dmers_path
  end 

  private 
  def dmer_params
    params.require(:dmer).permit(
      :customer_num,
      :client,
      :user_id,
      :store_prop_id,
      :get_date,
      :payment,
      :status,
      :before_status,
      :description,
      :settlement_payment,
      :picture_payment
    )
  end 
end
