class PaypaysController < ApplicationController

  def index 
    @q = Paypay.ransack(params[:q])
    @paypays = 
      if params[:q].nil?
        Paypay.none 
      else
        @q.result(distinct: false)
      end
      @paypays_data = @paypays.page(params[:page]).per(100)
      session[:previous_url] = request.referer
  end 

  def new 
    @store_prop = StoreProp.find(params[:store_id])
    @users = User.where.not(base: "退職")
    @paypay = Paypay.new()
  end 
  
  def create 
    @paypay = Paypay.new(paypay_params)
    @users = User.where.not(base: "退職")
    @store_prop = @paypay.store_prop_id
    @paypay.save
    if @paypay.save 
      redirect_to store_prop_path(@store_prop)
    else 
      render :new 
    end 
  end 

  def import 
    if params[:file].present?
      if Paypay.csv_check(params[:file]).present?
        redirect_to paypays_path , alert: "エラーが発生したため中断しました#{Paypay.csv_check(params[:file])}"
      else
        message = Paypay.import(params[:file]) 
        redirect_to paypays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to paypays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def show 
    @paypay = Paypay.find(params[:id])
  end 

  def edit 
    @paypay = Paypay.find(params[:id])
    @users = User.all
  end 
  
  def update 
    @paypay = Paypay.find(params[:id])
    @paypay.update(paypay_params)
    redirect_to paypay_path(@paypay.id)
  end 

  def destroy 
    @paypay = Paypay.find(params[:id])
    @paypay.destroy
    redirect_to session[:previous_url], alert: "#{@paypay.store_prop.name}のPayPay情報を削除しました。"
  end 

  private 

  def paypay_params 
    params.require(:paypay).permit(
      :customer_num,
      :client,
      :user_id,
      :store_prop_id,
      :date,
      :status,
      :status_update,
      :deficiency,
      :deficiency_solution,
      :result_point,
      :payment,
      :remarks,
      :profit,
      :valuation
    )
  end
end
