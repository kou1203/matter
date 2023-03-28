class PaymentDmersController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @q = PaymentDmer.ransack(params[:q])
    @payments = 
      if params[:q].nil?
        PaymentDmer.none 
      else
        @q.result(distinct: false)
      end
      @payments_data = @payments.page(params[:page]).per(100)
  end 

  def not_payment
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @dmers = Dmer.includes(:payment_dmers).where(status: "審査OK").where.not(industry_status: "要確認").where.not(industry_status: "NG").where.not(industry_status: "×")
    @payments = PaymentDmer.all
    @payments_result1 = @payments.where(result_category: "獲得手数料・初回決済手数料")
    @payments_result2 = @payments.where(result_category: "ステッカー連携手数料")
    @payments_result3 = @payments.where(result_category: "2回目決済手数料")
    @period = []
    month_cnt = 1
    12.times do 
      @period << Date.new(@month.year, month_cnt,1)
      month_cnt += 1
    end 
      
      


  end 

  def result1
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @dmers = Dmer.includes(:user,:payment_dmers,:store_prop).where(status: "審査OK")
    @dmers_result1 = 
      @dmers.where(result_point: @month.beginning_of_month..@month.end_of_month)
      .where(settlement_deadline: @month.beginning_of_month..)
      .where(settlement: ..@month.end_of_month).or(
        @dmers.where(result_point: ..@month.prev_month.end_of_month)
        .where(settlement_deadline: @month.beginning_of_month..)
        .where(settlement: @month.beginning_of_month..@month.end_of_month)
      )
      if params[:done] == "審査完了"
        @dmers_result1 = 
          @dmers.where(result_point: @month.beginning_of_month..@month.end_of_month)
          .where(status: "審査OK").where.not(industry_status: "NG").where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
      end 
    @client = params[:client]
    if @client.present?
      @dmers_result1 = @dmers_result1.where("dmers.client LIKE ?", "%#{@client}%")
    end 
      if params[:page_status] == "未発行"
        @page_status = params[:page_status]
      else  
        @page_status = ""
      
      end
    @payments = 
      PaymentDmer.where(result_category: "獲得手数料・初回決済手数料")
      .where(payment: @month.next_month.beginning_of_month..@month.next_month.end_of_month)
    # dメル成果で明細が発行されている案件
    @dmer_billing_data_exist = @dmers_result1.where(payment_dmers: {result_category: "獲得手数料・初回決済手数料"})
  end 

  def result2
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @dmers = Dmer.includes(:user,:payment_dmers,:store_prop).where(status: "審査OK")
    @dmers_result2 = 
      @dmers.where(result_point: @month.beginning_of_month..@month.end_of_month)
      .where(status_update_settlement: ..@month.end_of_month)
      .where(status_settlement: "完了").or(
        @dmers.where(result_point: ..@month.prev_month.end_of_month)
        .where(status_update_settlement: @month.beginning_of_month..@month.end_of_month)
        .where(status_settlement: "完了")
      )

      @client = params[:client]
      if @client.present?
        @dmers_result2 = @dmers_result2.where("dmers.client LIKE ?", "%#{@client}%")
      end 
      if params[:page_status] == "未発行"
        @page_status = params[:page_status]
      else  
        @page_status = ""
      
      end
    @payments = 
      PaymentDmer.where(result_category: "ステッカー連携手数料")
      .where(payment: @month.next_month.beginning_of_month..@month.next_month.end_of_month)
    # dメル成果で明細が発行されている案件
    @dmer_billing_data_exist = @dmers_result2.where(payment_dmers: {result_category: "ステッカー連携手数料"})
  end 

  def result3
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @dmers = Dmer.includes(:user,:payment_dmers,:store_prop).where(status: "審査OK")
    @dmers_result3 = 
      @dmers.where(settlement_second: @month.beginning_of_month..@month.end_of_month)
      .where(status_update_settlement: ..@month.end_of_month).where(status_settlement: "完了").or(
        @dmers.where(settlement_second: ..@month.prev_month.end_of_month)
        .where(status_update_settlement: @month.beginning_of_month..@month.end_of_month).where(status_settlement: "完了")
      )

      @client = params[:client]
      if @client.present?
        @dmers_result3 = @dmers_result3.where("dmers.client LIKE ?", "%#{@client}%")
      end 
      if params[:page_status] == "未発行"
        @page_status = params[:page_status]
      else  
        @page_status = ""
      
      end
    @payments = 
      PaymentDmer.where(result_category: "2回目決済手数料")
      .where(payment: @month.since(2.month).beginning_of_month..@month.since(2.month).end_of_month)
    # dメル成果で明細が発行されている案件
    @dmer_billing_data_exist = @dmers_result3.where(payment_dmers: {result_category: "2回目決済手数料"})
  end 

  def import 
    if params[:file].present?
      if PaymentDmer.csv_check(params[:file]).present?
        redirect_to payment_dmers_path , alert: "エラーが発生したため中断しました#{PaymentDmer.csv_check(params[:file])}"
      else
        message = PaymentDmer.import(params[:file]) 
        redirect_to payment_dmers_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to payment_dmers_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 
end
