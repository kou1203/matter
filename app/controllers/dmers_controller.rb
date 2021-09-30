class DmersController < ApplicationController
  before_action :authenticate_user!
  def index 
    @q = Dmer.includes(:store_prop, :user).ransack(params[:q])
    @dmers = 
      if params[:q].nil?
        Dmer.none 
      else
        @q.result(distinct: false)
      end
  end 

  def new 

    @dmer = Dmer.new
    @users = User.all
    @store_prop = StoreProp.find(params[:store_prop_id])
  end 
  
  def create 
    @dmer = Dmer.new(dmer_params)
    @users = User.all
    @store_prop = StoreProp.find(params[:store_prop_id])
    @dmer.save 
    if @dmer.save 
      redirect_to store_props_path(@store_prop.id) 
    else  
      render :new 
    end 
  end 

  def show 
    @dmer = Dmer.find(params[:id])
    @users = User.all
  end 

  def edit 
    @dmer = Dmer.find(params[:id])
    @users = User.all
  end 
  
  def update 
    @dmer = Dmer.find(params[:id])
    @dmer.update(dmer_params)
    redirect_to dmer_path(@dmer.id)
  end 

  def import 
    if params[:file].present?
      if Dmer.csv_check(params[:file]).present?
        redirect_to dmers_path , alert: "エラーが発生したため中断しました#{Dmer.csv_check(params[:file])}"
      else
        message = Dmer.import(params[:file]) 
        redirect_to dmers_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to dmers_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  private 
  def dmer_params
    params.require(:dmer).permit(
      :customer_num,
      :client,
      :user_id,
      :store_prop_id,
      :date,
      :share,
      :status,
      :status_update,
      :shipment,
      :settlementer_id,
      :settlement,
      :settlement_deadline,
      :status_settlement,
      :status_update_settlement,
      :payment,
      :payment_settlement,
      :result_point,
      :result_point_settlement,
      :deficiency,   
      :deficiency_settlement,   
      :deficiency_solution,
      :deficiency_solution_settlement,
      :deficiency_deadline,
      :deficiency_remarks, 
      :deficiency_remarks_settlement, 
      :description,
      :profit_new,
      :profit_settlement,
      :valuation_new,    
      :valuation_settlement
    )
  end 
end
