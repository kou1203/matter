class PaymentDmerSenbaisController < ApplicationController
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @q = PaymentDmerSenbai.ransack(params[:q])
    @payments = 
      if params[:q].nil?
        PaymentDmerSenbai.none 
      else
        @q.result(distinct: false)
      end
      @payments_data = @payments.page(params[:page]).per(100)
  end

  def import
    if params[:file].present?
      if PaymentDmerSenbai.csv_check(params[:file]).present?
        redirect_to payment_dmer_senbais_path , alert: "エラーが発生したため中断しました#{PaymentDmerSenbai.csv_check(params[:file])}"
      else
        message = PaymentDmerSenbai.import(params[:file]) 
        redirect_to payment_dmer_senbais_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to payment_dmer_senbais_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def result # 成果一覧ページ
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @dmer_senbai_done = 
    DmerSenbai.includes(:payment_dmer_senbais,:user).where(industry_status: "OK").where(app_check: "OK").where.not(dup_check: "重複").where(status: "審査OK").where(partner_status: "Active")
    @results = 
      @dmer_senbai_done.where(result_point: @month.all_month)
      .where(picture_check_date: ..@month.end_of_month)
    .or(
      @dmer_senbai_done.where(picture_check_date: @month.all_month)
      .where(result_point: ..@month.end_of_month)
    )
    @dmer_senbai_billing_data_exist = @results.where.not(payment_dmer_senbais: {id: nil})
    @payments = PaymentDmerSenbai.where(payment: @month.all_month)
    @clients = @results.group(:client)
    @client = params[:client]
    if @client.present?
      @results = @results.where("dmer_senbais.client LIKE ?", "%#{@client}%")
    end 
    if params[:page_status] == "未入金"
      @page_status = params[:page_status]
    else  
      @page_status = ""
    end

  end 
  
end
