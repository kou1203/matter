class NuroPaymentsController < ApplicationController

  def index 
    @q = NuroPayment.includes(:nuro).ransack(params[:q])
    @nuro_payments = 
      if params[:q].nil?
        NuroPayment.none 
      else
        @q.result(distinct: false)
      end
      @nuro_managemenet_fees = NuroManagemenetFee.all
      @nuro_payments_data = @nuro_payments.page(params[:page]).per(100)
      session[:previous_url] = request.referer
  end 

  def sales_details
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @nuros = Nuro.includes(:nuro_payments).all
    @nuro_payments = NuroPayment.includes(:nuro).where(payment: @month.all_month)
    @nuro_managemenet_fees = NuroManagemenetFee.where(payment: @month.all_month)
    @nuro_payment_links = NuroPayment.all
  end 

  def billings
    @other_client = params[:other_client]
    @date = params[:date].to_date
    @payment = params[:payment].to_date
     @nuro_payments = NuroPayment.where(date: @date.all_month).where(payment: @payment.all_month)
     @payment_fee = NuroManagemenetFee.where(date: @date.all_month).where(payment: @payment.all_month)
  end 

  def items
    @date = params[:date].to_date
    @payment = params[:payment].to_date
    @category = params[:category]
    @other_client = params[:other_client]
    @nuro_payments = 
      NuroPayment.where(date: @date.all_month)
      .where(payment: @payment.all_month).where(category: @category)
  end 


  def import
    if params[:file].present?
      # if Airpay.csv_check(params[:file]).present?
      #   redirect_to airpays_path , alert: "エラーが発生したため中断しました#{Airpay.csv_check(params[:file])}"
      # else
      message = NuroPayment.import(params[:file]) 
      redirect_to nuro_payments_path, alert: "インポート処理を完了しました#{message}"
      # end
    else
      redirect_to nuro_payments_path, alert: "インポートに失敗しました。ファイルの中身に問題ないか確認してください。"
    end
  end 

  def import_managemenet_fee
    if params[:file].present?
      # if Airpay.csv_check(params[:file]).present?
      #   redirect_to airpays_path , alert: "エラーが発生したため中断しました#{Airpay.csv_check(params[:file])}"
      # else
      message = NuroManagemenetFee.import(params[:file]) 
      redirect_to nuro_payments_path, alert: "インポート処理を完了しました#{message}"
      # end
    else
      redirect_to nuro_payments_path, alert: "インポートに失敗しました。ファイルの中身に問題ないか確認してください。"
    end
  end 
end
