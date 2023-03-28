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
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @airpays = Airpay.includes(:payment_airpay).where(status: "審査完了")
    @payments = PaymentAirpay.all
    @payments_result = @payments.where(result_category: "獲得手数料")
    @period = []
    month_cnt = 1
    12.times do 
      @period << Date.new(@month.year, month_cnt,1)
      month_cnt += 1
    end 
  end 


  def result
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @airpays = Airpay.includes(:user,:payment_airpay,:store_prop)  
    @airpays_result = @airpays.where(result_point: @month.beginning_of_month..@month.end_of_month).where(status: "審査完了")
      if params[:page_status] == "未発行"
        @page_status = params[:page_status]
      else  
        @page_status = ""
      end
    @payments = 
      PaymentAirpay.where(payment: @month.next_month.beginning_of_month..@month.next_month.end_of_month)
    # 成果で明細が発行されている案件
    @airpay_billing_data_exist = @airpays_result.where.not(payment_airpay: {airpay_id: nil})
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
