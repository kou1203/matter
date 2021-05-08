class DmersController < ApplicationController

  def index 
    @q = Dmer.ransack(params[:q])
    @dmers = @q.result(distinct: true)
  end 

  def new 
    @dmer = Dmer.new
    @users = User.all 
    @store_prop = StoreProp.find(params[:store_prop_id])
  end 
  
  def create 
    @dmer = Dmer.new(dmer_params)
    @users = User.all 
    @store_prop = StoreProp.find(params[:store_prop_id])
    @dmer.save 
    if @dmer.save 
      redirect_to dmers_path 
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
    @users = User.all 
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
      :store_prop_id, :user_id, :status,
      :get_date, :mail, :description,
      :payment, :settlement_payment, :picture_payment,
      :client
    )
  end 
end
