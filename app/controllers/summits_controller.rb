class SummitsController < ApplicationController

  def index 
    @q = Summit.ransack(params[:q])
    @summits = @q.result(distinct: true)
  end 

  def new 
    @summit = Summit.new
    @store_prop = StoreProp.find(params[:store_prop_id])
    @users = User.where(retiree: nil)
  end 
  
  def create 
    @users = User.where(retiree: nil)
    @store_prop = StoreProp.find(params[:store_prop_id])
    @summit = Summit.new(summit_params)
    @summit.save 
    if @summit.save
      redirect_to store_props_path(@store_prop.id)
    else  
      render :new
    end 
  end 

  def show 
    @summit = Summit.find(params[:id])
  end 

  def edit 
    @summit = Summit.find(params[:id])
    @users = User.where(retiree: nil)
  end 
  
  def update 
    @summit = Summit.find(params[:id])
    @summit.update(summit_params)
    redirect_to summits_path
  end 

  def destroy 
  end 
  private 

  def summit_params 
    params.require(:summit).permit(
      :customer_num,
      :client, 
      :user_id, 
      :store_prop_id, 
      :get_date,
      :status, 
      :before_status,
      :claim_house, 
      :claim_address, 
      :before_electric, 
      :supply_num, 
      :pay_as,
      :weight, 
      :menu, 
      :start, 
      :fee,
      :payment, 
      :remarks, 
    )
  end 

end
