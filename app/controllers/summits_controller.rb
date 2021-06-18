class SummitsController < ApplicationController

  def index 
    @q = Summit.ransack(params[:q])
    @summits = @q.result(distinct: true)
  end 

  def new 
    @users = User.all
    @summit_customer_prop = SummitCustomerProp.find(params[:summit_customer_prop_id])
    @summit = Summit.new
  end 
  
  def create 
    @users = User.all
    @summit_customer_prop = SummitCustomerProp.find(params[:summit_customer_prop_id])
    @summit = Summit.new(summit_params)
    @summit.save 
    if @summit.save
      redirect_to summit_customer_prop_path(@summit.summit_customer_prop.id)
    else  
      render :new
    end 
  end 

  def import 
    Summit.import(params[:file])
    redirect_to summits_path
  end 

  def show 
    @summit = Summit.find(params[:id])
    @summit_customer_prop = SummitCustomerProp.find(params[:id])
    @summits = @summit_customer_prop.summits
    @store_prop = @summit_customer_prop.store_prop
  end 

  def edit 
    @summit = Summit.find(params[:id])
    @users = User.all
  end 
  
  def update 
    @summit = Summit.find(params[:id])
    @summit.update(summit_params)
    redirect_to summit_customer_prop_path(@summit.summit_customer_prop.id)
  end 

  def destroy 
    @summit = Summit.find(params[:id])
    @summit.destroy 
    redirect_to summits_path
  end 
  private 

  def summit_params 
    params.require(:summit).permit(
      :summit_customer_prop_id, 
      :user_id, 
      :get_date,
      :payment,
      :status, 
      :before_status,
      :supply_num, 
      :contract_num,
      :menu,
      :plan,
      :contract_type,
      :contract_cap,
      :contract_cap_unit,
      :amount_use, 
      :start,
      :claim,
      :claim_expected,
      :remarks, 
    )
  end 

end
