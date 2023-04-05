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
    @rakuten_pays = RakutenPay.includes(:payment_rakuten_pay).where(status: "OK").where(payment_flag: "OK")
    @payments = PaymentRakutenPay.all
    @payments_result = @payments.where(result_category: "獲得手数料")
    @period = []
    month_cnt = 1
    12.times do 
      @period << Date.new(@month.year, month_cnt,1)
      month_cnt += 1
    end 
  end 

  def conf_index
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(2.month)
    @period = @month.ago(5.month)..@month
    @rakuten_pays = RakutenPay.includes(:payment_rakuten_pay,:store_prop).where(payment_rakuten_pay: {id: nil}).where(status: "OK").where(payment_flag: "OK").where(result_point: @period)
  end


  def result
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @rakuten_pays = RakutenPay.includes(:user,:payment_rakuten_pay,:store_prop)  
    if (2022 >= @month.year)
      @start_date = Date.new(@month.prev_month.year,@month.prev_month.month,16)
      @end_date = Date.new(@month.year,@month.month,15)
    elsif @month.year == 2023 && @month.month == 1
      @start_date = Date.new(@month.prev_month.year,@month.prev_month.month,16)
      @end_date = @month.end_of_month
    else    
      @start_date = @month.beginning_of_month
      @end_date = @month.end_of_month
    end 
    @rakuten_pays_result = @rakuten_pays.where(result_point: @start_date..@end_date).where(payment_flag: "OK")
      if params[:page_status] == "未入金"
        @page_status = params[:page_status]
      else  
        @page_status = ""
      end
    @payments = 
      PaymentRakutenPay.where(payment: @month.next_month.beginning_of_month..@month.next_month.end_of_month)
    # dメル成果で明細が発行されている案件
    @rakuten_pay_billing_data_exist = @rakuten_pays_result.where.not(payment_rakuten_pay: {rakuten_pay_id: nil})
  end 

end
