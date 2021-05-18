class PandasController < ApplicationController

  def index 
    @q = Panda.ransack(params[:q])
    @pandas = @q.result(distinct: true)
  end 

  def new 
    @panda = Panda.new 
    @users = User.where(retiree: nil)
    @store_prop = StoreProp.find(params[:store_prop_id])
  end 
  
  def create 
    @panda = Panda.new(panda_params)
    @users = User.whre(retiree: nil)
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
    @users = User.where(retiree: nil)
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
  end 

  private 

  def panda_params
    params.require(:panda).permit(
      :customer_num, 
      :client,
      :user_id,
      :store_prop_id,
      :get_date,
      :payment,
      :status,
      :before_status,
      :image_status, 
      :grid_id,
      :food_category,
      :ghost_flag,
      :docu_sign_send,
      :docu_sign_done,
      :confirmer,
      :solution_date,
      :remarks,
      :confirm_date,
      :tarminal_send,
      :result_point
    )
  end 

end
