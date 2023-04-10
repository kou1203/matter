class PaymentPaypaysController < ApplicationController
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(2.month)
    @q = PaymentPaypay.ransack(params[:q])
    @payments = 
      if params[:q].nil?
        PaymentPaypay.none 
      else
        @q.result(distinct: false)
      end
      @payments_data = @payments.page(params[:page]).per(100)
  end

  def not_payment
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(2.month)
    @paypays = Paypay.includes(:payment_paypay).where(status: "60審査可決")
    @payments = PaymentPaypay.all
    @payments_result = @payments
    @period = []
    month_cnt = 1
    12.times do 
      @period << Date.new(@month.year, month_cnt,1)
      month_cnt += 1
    end 
  end 

  def result
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @paypays = Paypay.includes(:user,:payment_paypay,:store_prop)  
    @paypays_result = @paypays.where(result_point: @month.beginning_of_month..@month.end_of_month).where(status: "60審査可決")
      if params[:page_status] == "未入金"
        @page_status = params[:page_status]
      else  
        @page_status = ""
      end
    @payments = 
      PaymentPaypay.where(payment: @month.since(2.month).beginning_of_month..@month.since(2.month).end_of_month)
    # 成果で明細が発行されている案件
    @paypay_billing_data_exist = @paypays_result.where.not(payment_paypay: {paypay_id: nil})
  end 


  def conf_index
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(2.month)
    @period = @month.ago(5.month)..@month
    @paypays = Paypay.includes(:payment_paypay,:store_prop).where(payment_paypay: {id: nil}).where(status: "60審査可決").where(result_point: @period)
  end 

  def import 
    if params[:file].present?
      if PaymentPaypay.csv_check(params[:file]).present?
        redirect_to payment_paypays_path , alert: "エラーが発生したため中断しました#{PaymentPaypay.csv_check(params[:file])}"
      else
        message = PaymentPaypay.import(params[:file]) 
        redirect_to payment_paypays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to payment_paypays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end
end
