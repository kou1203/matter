class StInsurancesController < ApplicationController

  def index 
    @q = StInsurance.ransack(params[:q])
    @st_insurances = 
      if params[:q].nil?
        StInsurance.none 
      else
        @q.result(distinct: true)
      end 
  end 
  
  def new 
    @store_prop = StoreProp.find(params[:store_prop_id])
    @users = User.all
    @st_insurance = StInsurance.new
  end 
  
  def create 
    @users = User.all
    @store_prop = StoreProp.find(params[:store_prop_id])
    @st_insurance = StInsurance.new(st_insurance_params)
    @st_insurance.save
    if @st_insurance.save
      redirect_to st_insurance_path(@st_insurance.id)
    else  
      render :new 
    end 
  end 

  def show 
    @st_insurance = StInsurance.find(params[:id]) 
  end 

  def edit 
    @users = User.all
    @st_insurance = StInsurance.find(params[:id])
  end 
  
  def update 
    @users = User.all
    @st_insurance = StInsurance.find(params[:id])
    @st_insurance.update(st_insurance_params)
    redirect_to st_insurances_path
  end 

  def import 
    if params[:file].present?
      if StInsurance.csv_check(params[:file]).present?
        redirect_to st_insurances_path , alert: "エラーが発生したため中断しました#{StInsurance.csv_check(params[:file])}"
      else
        message = StInsurance.import(params[:file]) 
        redirect_to st_insurances_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to st_insurances_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end  

  private 

  def st_insurance_params 
    params.require(:st_insurance).permit(
      :client,
      :user_id,
      :store_prop_id,
      :date,
      :status,
      :status_update,
      :deficiency,
      :deficiency_solution,
      :payment,
      :remarks,
      :result_point,
      :profit,
      :valuation
    )
  end
end
