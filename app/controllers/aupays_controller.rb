class AupaysController < ApplicationController

  def index 
    @q = Aupay.includes(:user, :store_prop).ransack(params[:q])
    @aupays = 
      if params[:q].nil?
        Aupay.none 
      else 
        @q.result(distinct: false)
      end
  end

  def new 
    @aupay = Aupay.new
    @store_prop = StoreProp.find(params[:store_prop_id])
    @users = User.all
  end
  
  def create 
    @store_prop = StoreProp.find(params[:store_prop_id])
    @users = User.all
    @aupay = Aupay.new(aupay_params)
    @aupay.save 
    if @aupay.save 
      redirect_to store_prop_path(@store_prop.id)
    else  
      render :new 
    end 
  end

  def import
    Aupay.import(params[:file])
    redirect_to aupays_path
  end 

  def show 
    @aupay = Aupay.find(params[:id])
    @users = User.all
  end 
  
  def edit 
    @aupay = Aupay.find(params[:id])
    @users = User.all
  end 
  
  def update 
    @aupay = Aupay.find(params[:id])
    @aupay.update(aupay_params)
    redirect_to aupay_path(@aupay.id) 
  end 

  private 
  def aupay_params 
    params.require(:aupay).permit(
      :customer_num,
      :client,
      :user_id,
      :store_prop_id,
      :get_date,
      :payment,
      :status,
      :before_status,
      :settlement,
      :settlement_deadline,
      :description,
      :valuation_profit,
      :actual_profit,
    )

  end 
  
end
