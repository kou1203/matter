class PandasController < ApplicationController

  def index 
    @q = Panda.ransack(params[:q])
    @pandas = 
      if params[:q].nil?
        Panda.none 
      else
        @q.result(distinct: true)
      end
  end 

  def new 
    @panda = Panda.new 
    @store_prop = StoreProp.find(params[:store_prop_id])
  end 
  
  def create 
    @panda = Panda.new(panda_params)
    @store_prop = StoreProp.find(params[:store_prop_id])
    @panda.save 
    if @panda.save 
      redirect_to store_props_path(@store_prop.id)
    else  
      render :new 
    end 
  end 

  def show 
    @panda = Panda.find(params[:id])

  end 

  def edit 
    @panda = Panda.find(params[:id])
    @users = User.all
  end 
  
  def update 
    @panda = Panda.find(params[:id])
    @panda.update(panda_params)
    if @panda.update(panda_params)
      redirect_to pandas_path 
    else  
      render :edit
    end 
  end 

  def destroy 
  end 

  def import 
    Panda.import(params[:file])
    redirect_to pandas_path
  end 

  private 

  def panda_params
    params.require(:panda).permit(
      :grid_id,
      :food_category,
      :client,
      :user_id,
      :store_prop_id,
      :get_date,
      :ghost_flag,
      :docu_sign_send,
      :docu_sign_done,
      :quality_check,
      :delivery_arrangements,
      :traning,
      :result_point,
      :payment,
      :remarks,
      :status, 
      :confirm_ball,
      :confirm_date,
      :confirmer,
      :deficiency,
      :deficiency_result,
      :solution_date,
      :valuation_profit,
      :actual_profit
    )
  end 

end
