class PaypaysController < ApplicationController

  def index 
    @q = Paypay.ransack(params[:q])
    @paypays = @q.result(distinct: true)
  end 

  def new 
    @paypay = Paypay.new
    @users = User.where(retire: nil)
    @store_prop = StoreProp.find(params[:store_prop_id])
    
  end 
  
  def create 
    @paypay = Paypay.new(paypay_params)
    @users = User.where(retire: nil)
    @store_prop = StoreProp.find(params[:store_prop_id])
    @paypay.save
    if @paypay.save 
      redirect_to store_prop_path(@store_prop.id)
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
    @users = User.where(retiree: nil)
  end 
  
  def update 
    @paypay = Paypay.find(params[:id])
    @paypay.update(paypay_params)
    redirect_to paypays_path
  end 

  private 

  def paypay_params 
    params.require(:paypay).permit(
      :client,
      :user_id,
      :store_prop_id,
      :get_date,
      :payment,
      :status,
      :before_status
    )
  end
end
