class PaymentItssesController < ApplicationController
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(1.month)
    @q = PaymentItss.ransack(params[:q])
    @payments = 
      if params[:q].nil?
        PaymentItss.none 
      else
        @q.result(distinct: false)
      end
      @payments_data = @payments.page(params[:page]).per(100)
  end

  def not_payment
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(1.month)
    @itsses = Itss.includes(:payment_itss).where(status_ntt1: "工事完了")
    @payments = PaymentItss.all
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
    @itsses = Itss.includes(:user,:payment_itss)  
    @itsses_result = @itsses.where(construction_schedule: @month.beginning_of_month..@month.end_of_month).where(status_ntt1: "工事完了")
      if params[:page_status] == "未入金"
        @page_status = params[:page_status]
      else  
        @page_status = ""
      end
    @payments = 
      PaymentItss.where(payment: @month.since(2.month).beginning_of_month..@month.since(2.month).end_of_month)
    # 成果で明細が発行されている案件
    @itss_billing_data_exist = @itsses_result.where.not(payment_itss: {itss_id: nil})
  end 

  def conf_index
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.ago(1.month)
    @period = @month.ago(5.month)..@month
    @itsses = Itss.includes(:payment_itss).where(payment_itss: {id: nil}).where(status_ntt1: "工事完了").where(construction_schedule: @period)
  end 

  def import 
    if params[:file].present?
      if PaymentItss.csv_check(params[:file]).present?
        redirect_to payment_itsses_path , alert: "エラーが発生したため中断しました#{PaymentItss.csv_check(params[:file])}"
      else
        message = PaymentItss.import(params[:file]) 
        redirect_to payment_itsses_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to payment_itsses_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end
end
