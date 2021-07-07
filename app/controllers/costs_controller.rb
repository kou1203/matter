class CostsController < ApplicationController

  def index 
    @q = Cost.ransack(params[:q])
    @costs = 
      if params[:q].nil?
        Cost.none
      else  
        @q.result(distinct: false)
      end
  end 
  
  def new 
    @cost = Cost.new
  end 
  
  def create 
    @cost = Cost.new(cost_params)
    if @cost.save
      redirect_to root_path
    else  
      render :new 
    end 
  end 

  def edit 
    @cost = Cost.find(params[:id])
  end 
  
  def update 
    @cost = Cost.find(params[:id])
    @cost.update(cost_params)
    redirect_to costs_path
  end 

  private 
  def cost_params 
    params.require(:cost).permit(
      :year, 
      :month, 
      :base,
      :sales_man, 
      :office_worker, 
      :social_insurance, 
      :administrator, 
      :sales_man_cost, 
      :office_worker_cost, 
      :office, 
      :utility_net_cost, 
      :dorm, 
      :bonus_stock  , 
      :travel_stock , 
      :other , 
      :update_date
    )
  end 
end
