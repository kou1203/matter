class AupaysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_aupay, only: [:show,:edit,:update]
  before_action :back_retirement

  def index 
    @q = Aupay.includes(:user, :store_prop).ransack(params[:q])
    @aupays = 
      if params[:q].nil?
        Aupay.none 
      else 
        @q.result(distinct: false)
      end
      @aupays_data = @aupays.page(params[:page]).per(100)
  end

  def new 
    @store_prop = StoreProp.find(params[:store_id])
    @aupay = Aupay.new
    @users = User.where.not(position: "退職")
  end
  
  def create 
    @users = User.where.not(position: "退職")
    @aupay = Aupay.new(aupay_params)
    @store_prop = StoreProp.find(@aupay.store_prop_id)
    @aupay.save 
    if @aupay.save 
      redirect_to store_prop_path(@aupay.store_prop_id)
    else  
      render :new
    end 
  end

  def import 
    if params[:file].present?
      if Aupay.csv_check(params[:file]).present?
        redirect_to aupays_path , alert: "エラーが発生したため中断しました#{Aupay.csv_check(params[:file])}"
      else
        message = Aupay.import(params[:file]) 
        redirect_to aupays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to aupays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 
  
  def show 
    @users = User.all
  end 
  
  def edit 
    @users = User.all
    @aupay = Aupay.find(params[:id])
  end 
  
  def update 
    @aupay.update(aupay_params)
    redirect_to aupay_path(@aupay.id) 
  end 

  def destroy 
    @aupay = Aupay.find(params[:id])
    @aupay.destroy 
    redirect_to aupays_path, alert: "#{@aupay.store_prop.name}を削除しました。"
  end 

  private 
  def set_aupay
    @aupay = Aupay.find(params[:id])
  end 

  def aupay_params 
    params.require(:aupay).permit(
      :customer_num,
      :record_num,
      :client,
      :user_id,
      :store_prop_id,
      :date,
      :share,
      :status,
      :status_update,
      :settlementer_id,
      :shipment,
      :picture,
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
     
  def back_retirement # 退職者が閲覧できないようにする
    redirect_to error_pages_path if current_user.position_sub == "99：退職"
  end
  
end
