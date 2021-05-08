class PaypaysController < ApplicationController

  def index 
    @q = Paypay.ransack(params[:q])
    @paypays = @q.result(distinct: true)
  end 

  def new 
    @paypay = Paypay.new
    @users = User.all 
    @store_prop = StoreProp.find(params[:store_prop_id])
    
  end 
  
  def create 
    @paypay = Paypay.new(paypay_params)
    @users = User.all 
    @store_prop = StoreProp.find(params[:store_prop_id])
    @paypay.save
    if @paypay.save 
      redirect_to paypays_path 
    else 
      render :new 
    end 
  end 

  def import 
    Paypay.import(params[:file])
    redirect_to paypay_path
  end 

  def show 
    @paypay = Paypay.find(params[:id])
  end 

  def edit 
    @paypay = Paypay.find(params[:id])
    @users = User.all
  end 
  
  def update 
    @paypay = Paypay.find(params[:id])
    @users = User.all
    @paypay.update(paypay_params)
    redirect_to paypays_path
  end 

  private 

  def paypay_params 
    params.require(:paypay).permit(
      :store_prop_id, :user_id, :client,
      :get_date, :status, :payment
    )
  end
end
