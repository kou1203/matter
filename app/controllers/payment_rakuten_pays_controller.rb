class PaymentRakutenPaysController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @q = PaymentRakutenPay.ransack(params[:q])
    @payments = 
      if params[:q].nil?
        PaymentRakutenPay.none 
      else
        @q.result(distinct: false)
      end
      @payments_data = @payments.page(params[:page]).per(100)
  end 

  def import 
    if params[:file].present?
      if PaymentRakutenPay.csv_check(params[:file]).present?
        redirect_to payment_rakuten_pays_path , alert: "エラーが発生したため中断しました#{PaymentRakutenPay.csv_check(params[:file])}"
      else
        message = PaymentRakutenPay.import(params[:file]) 
        redirect_to payment_rakuten_pays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to payment_rakuten_pays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def not_payment 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    if @month > Date.new(2023,02,28)
      @start_date = @month.ago(1.month).beginning_of_month
      @end_date = @month.ago(1.month).end_of_month
    else  
      @start_date = Date.new(@month.ago(2.month).year,@month.ago(2.month).month,16)
      @end_date = Date.new(@month.year,@month.prev_month.month,15)
    end 
    @results_monthly = RakutenPay.where(payment: @month.beginning_of_month..@month.end_of_month).where(status: "OK").where.not(payment_flag: "NG")
    @payments_monthly = PaymentRakutenPay.includes(:rakuten_pay).where(payment: @month.beginning_of_month..@month.end_of_month)
    @payments_monthly_ng = @payments_monthly.where(rakuten_pay: {status: "CANCEL"})
    @billing_date = PaymentRakutenPay.all

  end 
end
