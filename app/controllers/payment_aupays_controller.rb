class PaymentAupaysController < ApplicationController

  def index
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(2.month)
    @q = PaymentAupay.ransack(params[:q])
    @payments = 
      if params[:q].nil?
        PaymentAupay.none 
      else
        @q.result(distinct: false)
      end
      @payments_data = @payments.page(params[:page]).per(100)
  end 

  def not_payment
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(1.month)
    @aupays = Aupay.includes(:payment_aupay).where(status: "審査通過")
    @payments = PaymentAupay.all
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
    @aupays = Aupay.includes(:user,:payment_aupay,:store_prop)  
    @aupays_result = @aupays.where(status_update_settlement: @month.beginning_of_month..@month.end_of_month).where(status: "審査通過").where(status_settlement: "完了")
      if params[:page_status] == "未入金"
        @page_status = params[:page_status]
      else  
        @page_status = ""
      end
    @payments = 
      PaymentAupay.where(payment: @month.since(1.month).beginning_of_month..@month.since(1.month).end_of_month)
    # 成果で明細が発行されている案件
    @aupay_billing_data_exist = @aupays_result.where.not(payment_aupay: {aupay_id: nil})
  end 

  def conf_index
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(2.month)
    @period = @month.ago(5.month)..@month
    @aupays = Aupay.includes(:payment_aupay,:store_prop).where(payment_aupay: {id: nil}).where(status: "審査通過").where(status_update_settlement: @period)
  end 

  def import
    if params[:file].present?
      if PaymentAupay.csv_check(params[:file]).present?
        redirect_to payment_aupays_path , alert: "エラーが発生したため中断しました#{PaymentAupay.csv_check(params[:file])}"
      else
        message = PaymentAupay.import(params[:file]) 
        redirect_to payment_aupays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to payment_aupays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

end
