class PaymentAirpaysController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(2.month)
    @q = PaymentAirpay.ransack(params[:q])
    @payments = 
      if params[:q].nil?
        PaymentAirpay.none 
      else
        @q.result(distinct: false)
      end
      @payments_data = @payments.page(params[:page]).per(100)
  end 

  def not_payment
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(2.month)
    @client = params[:client]
    @results_monthly = Airpay.where(payment: @month.beginning_of_month..@month.end_of_month).where(status: "審査完了")
    @payments_monthly = PaymentAirpay.includes(:airpay).where(payment: @month.beginning_of_month..@month.end_of_month)
    @billing_date = PaymentAirpay.all
  end 

  def import 
    if params[:file].present?
      if PaymentAirpay.csv_check(params[:file]).present?
        redirect_to payment_airpays_path , alert: "エラーが発生したため中断しました#{PaymentAirpay.csv_check(params[:file])}"
      else
        message = PaymentAirpay.import(params[:file]) 
        redirect_to payment_airpays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to payment_airpays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end


end
