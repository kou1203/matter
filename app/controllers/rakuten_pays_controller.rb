class RakutenPaysController < ApplicationController

  def index 
    @q = RakutenPay.includes(:store_prop).ransack(params[:q])
    @rakuten_pays = 
    if params[:q].nil?
      RakutenPay.none 
    else  
      @q.result(distinct: true)
    end
    @rakuten_pays_data = @rakuten_pays.page(params[:page]).per(100)
  end 

  def new
    @rakuten_pay = RakutenPay.new 
    @users = User.all 
    @store_prop = StoreProp.find(params[:store_prop_id]) 
  end  
  
  def create 
    @rakuten_pay = RakutenPay.new(rakuten_pay_params)
    @users = User.all 
    @store_prop = StoreProp.find(params[:store_prop_id])
    if @rakuten_pay.save 
      redirect_to rakuten_pay_path(@rakuten_pay.id) 
    else  
      render :new 
    end 
  end 
  
  def edit 
    @rakuten_pay = RakutenPay.find(params[:id])
    @users = User.all 
  end 
  
  def update 
    @rakuten_pay = RakutenPay.find(params[:id])
    @rakuten_pay.update(rakuten_pay_params)
    redirect_to rakuten_pay_path(@rakuten_pay.id) 
  end 

  def show 
    @rakuten_pay = RakutenPay.find(params[:id])
  end 

  def import 
    if params[:file].present?
      if RakutenPay.csv_check(params[:file]).present?
        redirect_to rakuten_pays_path , alert: "エラーが発生したため中断しました#{RakutenPay.csv_check(params[:file])}"
      else
        message = RakutenPay.import(params[:file]) 
        redirect_to rakuten_pays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to rakuten_pays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def deficiency
  end 

  private 
  def rakuten_pay_params 
    params.require(:rakuten_pay).permit(
      :client,
      :user_id,
      :store_prop_id,
      :date,
      :share,
      :status,
      :transcript,
      :customer_num,
      :status_update,
      :deficiency,
      :deficiency_solution,
      :payment,
      :deficiency_info,
      :deficiency_consent,
      :result_point,
      :profit,
      :valuation
    )
  end
end
