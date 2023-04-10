class PaymentCashesController < ApplicationController

  def index
    # 期間
      @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
      @prev_month = @month.ago(1.month) 
      @prev_2month = @month.ago(2.month)
    # 明細
      @dmer_payment = PaymentDmer.where(payment: @month.beginning_of_month..@month.end_of_month)
      @rakuten_pay_payment = PaymentRakutenPay.where(payment: @month.beginning_of_month..@month.end_of_month)
      @airpay_payment = PaymentAirpay.where(payment: @month.beginning_of_month..@month.end_of_month)
      @paypay_payment = PaymentPaypay.where(payment: @month.beginning_of_month..@month.end_of_month)
      @aupay_payment = PaymentAupay.where(payment: @month.beginning_of_month..@month.end_of_month)
      @itss_payment = PaymentItss.where(payment: @month.beginning_of_month..@month.end_of_month)
    # 商材
    # dメル
      @dmers = Dmer.includes(:payment_dmers)
      @dmer_result1 = 
      @dmers.where(result_point: @prev_month.beginning_of_month..@prev_month.end_of_month)
      .where(settlement_deadline: @prev_month.beginning_of_month..)
      .where(settlement: ..@prev_month.end_of_month)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      .or(
        @dmers.where(settlement: @prev_month.beginning_of_month..@prev_month.end_of_month)
        .where(settlement_deadline: @prev_month.beginning_of_month..)
        .where(result_point: ...@prev_month.end_of_month)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
      )
    
      @dmer_result2 = 
      @dmers.where(status_update_settlement: @prev_month.beginning_of_month..@prev_month.end_of_month)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
    
      @dmer_result3 = 
      @dmers.where(status_update_settlement: @prev_2month.beginning_of_month..@prev_2month.end_of_month)
        .where(settlement_second: ..@prev_2month.end_of_month)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
        .or(
          @dmers.where(settlement_second: @prev_2month.beginning_of_month..@prev_2month.end_of_month)
          .where(status_update_settlement: ...@prev_2month.end_of_month)
          .where(status: "審査OK")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status_settlement: "完了")
        )
    # 楽天ペイ
      @rakuten_pays = RakutenPay.includes(:user,:payment_rakuten_pay,:store_prop)  
      if (2022 >= @prev_2month.year)
        @start_date = Date.new(@prev_2month.year,@prev_2month.month,16)
        @end_date = Date.new(@prev_month.year,@prev_month.month,15)
      else    
        @start_date = @prev_2month.beginning_of_month
        @end_date = @prev_2month.end_of_month
      end 
      @rakuten_pays_result = 
        @rakuten_pays.where(result_point: @start_date..@end_date).where(payment_flag: "OK")
        .where("? > share", Date.new(2023,1,1))
    # AirPay
      @airpays = Airpay.includes(:user,:payment_airpay,:store_prop)  
      @airpays_result = @airpays.where(result_point: @prev_2month.beginning_of_month..@prev_2month.end_of_month).where(status: "審査完了")
    # PayPay
      @paypays = Paypay.includes(:user,:payment_paypay,:store_prop)  
      @paypays_result = @paypays.where(result_point: @prev_2month.beginning_of_month..@prev_2month.end_of_month).where(status: "60審査可決")
    # auPay
      @aupays = Aupay.includes(:user,:payment_aupay,:store_prop)  
      @aupays_result = @aupays.where(status_update_settlement: @prev_month.beginning_of_month..@prev_month.end_of_month).where(status: "審査通過").where(status_settlement: "完了")
    # ITSS
      @itsses = Itss.includes(:user,:payment_itss)  
      @itsses_result = @itsses.where(construction_schedule: @prev_month.beginning_of_month..@prev_month.end_of_month).where(status_ntt1: "工事完了")
  end 
end

