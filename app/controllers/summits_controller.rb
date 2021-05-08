class SummitsController < ApplicationController

  def index 
    @q = Summit.ransack(params[:q])
    @summits = @q.result(distinct: true)
  end 

  def new 
    @summit = Summit.new
    @store_prop = StoreProp.find(params[:store_prop_id])
    @users = User.all
  end 
  
  def create 
    @users = User.all
    @store_prop = StoreProp.find(params[:store_prop_id])
    @summit = Summit.new(summit_params)
    @summit.save 
    if @summit.save
      redirect_to summits_path 
    else  
      render :new
    end 
  end 

  def show 
    @summit = Summit.find(params[:id])
  end 

  def edit 
    @summit = Summit.find(params[:id])
    @users = User.all
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
      :user_id, :store_prop_id, :get_date,
      :claim_house, :claim_address, :mail,
      :before_electric, :supply_num, :pay_as,
      :weight, :menu, :start, :fee,
      :payment, :remarks , :client
    )
  end 

end
