class AupaysController < ApplicationController
  before_action :authenticate_user!
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
      session[:error] = @aupay.errors.full_messages
      
      redirect_to store_prop_aupays_new_path(@store_prop.id)
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
  
end
