class AupaysController < ApplicationController

  def index 
    @q = Aupay.ransack(params[:q])
    @aupays = @q.result(distinct: true)
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
    @users = User.all 
    @aupay.save 
    if @aupay.save 
      flash[:notice] = "登録完了しました！"
      redirect_to aupays_path
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
  end 
  
  def edit 
    @aupay = Aupay.find(params[:id])
    @users = User.all
  end 
  
  def update 
    @aupay = Aupay.find(params[:id])
    @aupay.update(aupay_params)
    flash[:notice] = "編集が完了しました！"
    redirect_to aupays_path 
  end 

  private 
  def aupay_params 
    params.require(:aupay).permit(
      :store_prop_id, :user_id, :get_date,
      :status, :mail, :client, :payment, :settlement, :description
    )

  end 
  
end
