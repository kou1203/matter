class ProfitsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @calc_periods = CalcPeriod.where(sales_category: "評価売")
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    # calc_period_and_perは"@calc_periods"と"@month"の配置を先にするのが必須
    calc_period_and_per
    # dメル
    @dmer_done = 
      Dmer.where(result_point: @dmer1_start_date..@dmer1_end_date)
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      .where(status: "審査OK")
      @dmers_slmt = 
      Dmer.where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    @dmer_slmt_done = 
      @dmers_slmt.where(status_update_settlement: @dmer2_start_date..@dmer2_end_date)
      .where(result_point: ..@dmer2_end_date)
      .where(status_settlement: "完了").or(
        @dmers_slmt.where(status_update_settlement: ..@dmer2_end_date)
        .where(result_point: @dmer2_start_date..@dmer2_end_date)
        .where(status_settlement: "完了")

      )
      @dmer_slmt2nd_done = 
      @dmers_slmt.where(settlement_second: @dmer3_start_date..@dmer3_end_date)
      .where(status_settlement: "完了")
      .where(status_update_settlement: ..@dmer3_end_date)
      .where(result_point: ..@dmer3_end_date)
      .or(
        @dmers_slmt.where(settlement_second: ..@dmer3_end_date)
        .where(status_settlement: "完了")
        .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
        .where(result_point: ..@dmer3_end_date)
      )
      .or(
        @dmers_slmt.where(settlement_second: ..@dmer3_end_date)
        .where(status_settlement: "完了")
        .where(status_update_settlement: ..@dmer3_end_date)
        .where(result_point: @dmer3_start_date..@dmer3_end_date)
      )

      # auPay
      @aupays_slmt = Aupay.where(status: "審査通過")
      @aupay_slmt_done = @aupays_slmt.where(status_update_settlement: @aupay1_start_date..@aupay1_end_date).where(status_settlement: "完了")

      # PayPay
      @paypay_done = 
      Paypay.where(result_point: @paypay1_start_date..@paypay1_end_date)
      .where(status: "60審査可決")

      # 楽天ペイ
      @rakuten_pays = RakutenPay.where(date: @rakuten_pay1_start_date..@rakuten_pay1_end_date)
      @rakuten_pay_val = 
      @rakuten_pays.where.not(status: "自社NG").where.not(status: "自社不備")
      .where(deficiency: nil)
      .or(
        RakutenPay.where.not(status: "自社NG").where.not(status: "自社不備")
        .where.not(deficiency: nil)
        .where(share: @rakuten_pay1_start_date..@rakuten_pay1_end_date)
        )
      # AirPay
      @airpay_done = 
      Airpay.where(status: "審査完了")
        .where(result_point: @airpay1_start_date..@airpay1_end_date)
      # ITSS
      @itss = Itss.where(construction_schedule: @itss1_start_date..@itss1_end_date).where(status_ntt1: "工事完了")


  end 

  def profit_export_by_spreadsheet
  end

  def product_export_by_spreadsheet
  end 

  def sum_export 
  end


end
