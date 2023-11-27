class ValuationResultsController < ApplicationController
  before_action :set_month
  before_action :set_result

  def index
  end 

  def product
    @product_name = params[:product_name]
  end 

  def show
    @user_id = params[:id]
    @product_name = params[:product_name]
  end 

  private 
    def set_month 
      @month = params[:month] ? Time.parse(params[:month]) : Date.today
    end 

    def set_result
      # dメル
      @dmers = Dmer.where(industry_status: "OK").where(status: "審査OK")
      @dmer_result1 = @dmers.where(result_point: @month.all_month)
      @dmer_result2 = 
        @dmers.where(status_settlement: "完了").where(result_point: @month.all_month).where(status_update_settlement: ..@month.end_of_month).or(
          @dmers.where(status_settlement: "完了").where(result_point: ..@month.end_of_month).where(status_update_settlement: @month.all_month)
        )
      @dmer_result3 = 
        @dmers.where(status_settlement: "完了").where(result_point: @month.all_month).where(status_update_settlement: ..@month.end_of_month).where(settlement_second: ..@month.end_of_month).or(
          @dmers.where(status_settlement: "完了").where(result_point: ..@month.end_of_month).where(status_update_settlement: @month.all_month).where(settlement_second: ..@month.end_of_month)
        ).or(
          @dmers.where(status_settlement: "完了").where(result_point: ..@month.end_of_month).where(status_update_settlement: ..@month.end_of_month).where(settlement_second: @month.all_month)
        )

        # dメル専売
        @dmer_senbai_done = 
        DmerSenbai.where(industry_status: "OK")
        .where(app_check: "OK")
        .where.not(dup_check: "重複")
        .where(partner_status: "Active")
        .where(status: "審査OK")
      @dmer_senbai_done_slmter = 
        DmerSenbai.where(industry_status: "OK")
        .where(app_check: "OK")
        .where.not(dup_check: "重複")
        .where(partner_status: "Active")
        .where(status: "審査OK").where(status_settlement: "完了").where(picture_check: "合格")
      # dメル成果1
      @dmer_senbai_result1 = @dmer_senbai_done.where(result_point: @month.all_month)
      # dメル成果2
      @dmer_senbai_result2 = 
        @dmer_senbai_done_slmter.where(result_point: @month.all_month)
        .where(picture_check_date: ..@month.end_of_month)
        .or(
        @dmer_senbai_done_slmter.where(result_point: ..@month.end_of_month)
        .where(picture_check_date: @month.all_month)
        )
        # dメル成果3
        @dmer_senbai_result3 = 
          @dmer_senbai_done_slmter.where(result_point: @month.all_month).where(picture_check_date: ..@month.end_of_month).where.not(picture_check_date: nil)
          .where(settlement_second: ..@month.end_of_month)
            .or(
              @dmer_senbai_done_slmter.where(result_point: ..@month.end_of_month)
              .where(picture_check_date: @month.all_month)
              .where(settlement_second: ..@month.end_of_month)
            )
            .or(
              @dmer_senbai_done_slmter.where(result_point: ..@month.end_of_month)
              .where(picture_check_date: ..@month.end_of_month)
              .where(settlement_second: @month.all_month)
            )
      @aupay_result = 
        Aupay.where(status: "審査通過").where(status_settlement: "完了").where(status_update_settlement: @month.all_month)
      @paypay_result = 
        Paypay.where(status: "60審査可決").where(result_point: @month.all_month)
      @rakuten_pay_result = 
        RakutenPay.where(date: @month.all_month).where.not(status: "自社不備").where.not(status: "自社NG").or(
          RakutenPay.where.not(date: @month.all_month).where.not(deficiency: nil).where(share: @month.all_month)
        )
      @airpay_result = 
        Airpay.where(result_point: @month.all_month).where.not(status: "審査OK")
        @airpay_sum_valuation = 0
        @airpay_result.group(:user_id).each do |air_user|
          if @airpay_result.where(user_id: air_user.user_id).length >= 20
            @airpay_sum_valuation += @airpay_result.where(user_id: air_user.user_id).length * 8000
          elsif @airpay_result.where(user_id: air_user.user_id).length >= 10
            @airpay_sum_valuation += @airpay_result.where(user_id: air_user.user_id).length * 6000
          else  
            @airpay_sum_valuation += @airpay_result.where(user_id: air_user.user_id).sum(:valuation)
          end 
        end 
      @itss_result = 
        Itss.where(status_ntt1: "工事完了").where(construction_schedule: @month.all_month)
      @demaekan_result = 
        Demaekan.where(first_cs_contract: Date.new(@month.prev_month.year,@month.prev_month.month,26)..Date.new(@month.year,@month.month,25))
      @usen_pays = UsenPay.where(date: @month.all_month)
      usen_separate_date = Date.new(2023,8,1)
      @usen_pays_7month_ago = 
        UsenPay.where(date: ...usen_separate_date).where(result_point: @month.all_month)
        .where.not(status: "自社不備").where.not(status: "自社NG") rescue 0
      @usen_pays_8month_since = 
        UsenPay.where(date: usen_separate_date..).where(date: @month.all_month)
        .where.not(status: "自社不備").where.not(status: "自社NG") rescue 0

      @products = {}
      @products["dメル（審査完了）"] = [@dmer_result1.length,@dmer_result1.sum(:valuation_new)]
      @products["dメル（決済+写真）"] = [@dmer_result2.length,@dmer_result2.sum(:valuation_settlement)]
      @products["dメル2回目決済"] = [@dmer_result3.length,@dmer_result3.sum(:valuation_second_settlement)]
      @products["dメル専売（審査完了）"] = [@dmer_senbai_result1.length,@dmer_senbai_result1.sum(:valuation_new)]
      @products["dメル専売（決済+写真）"] = [@dmer_senbai_result2.length,@dmer_senbai_result2.sum(:valuation_settlement)]
      @products["dメル専売2回目決済"] = [@dmer_senbai_result3.length,@dmer_senbai_result3.sum(:valuation_second_settlement)]
      @products["auPay（写真）"] = [@aupay_result.length,@aupay_result.sum(:valuation_settlement)]
      @products["PayPay（審査完了）"] = [@paypay_result.length,@paypay_result.sum(:valuation)]
      @products["楽天ペイ（獲得）"] = [@rakuten_pay_result.length,@rakuten_pay_result.sum(:valuation)]
      @products["AirPay（審査完了）"] = [@airpay_result.length,@airpay_sum_valuation]
      @products["ITSS（工事完了）"] = [@itss_result.length,@itss_result.sum(:valuation)]
      @products["出前館（CS締結日）"] = [@demaekan_result.length,@demaekan_result.sum(:valuation)]
      @products["UsenPay2023年7月以前"] = [@usen_pays_7month_ago.length,@usen_pays_7month_ago.sum(:valuation)]
      @products["UsenPay2023年8月以降"] = [@usen_pays_8month_since.length,@usen_pays_8month_since.sum(:valuation)]
      
      @product_data = {}
      @product_data["dメル（審査完了）"] = [@dmer_result1.includes(:store_prop,:user)]
      @product_data["dメル（決済+写真）"] = [@dmer_result2.includes(:store_prop,:user)]
      @product_data["dメル2回目決済"] = [@dmer_result3.includes(:store_prop,:user)]
      @product_data["dメル専売（審査完了）"] = [@dmer_senbai_result1.includes(:user)]
      @product_data["dメル専売（決済+写真）"] = [@dmer_senbai_result2.includes(:user)]
      @product_data["dメル専売2回目決済"] = [@dmer_senbai_result3.includes(:user)]
      @product_data["auPay（写真）"] = [@aupay_result.includes(:store_prop,:user)]
      @product_data["PayPay（審査完了）"] = [@paypay_result.includes(:store_prop,:user)]
      @product_data["楽天ペイ（獲得）"] = [@rakuten_pay_result.includes(:store_prop,:user)]
      @product_data["AirPay（審査完了）"] = [@airpay_result.includes(:store_prop,:user)]
      @product_data["ITSS（工事完了）"] = [@itss_result.includes(:user)]
      @product_data["出前館（CS締結日）"] = [@demaekan_result.includes(:store_prop,:user)]
      @product_data["UsenPay2023年7月以前"] = [@usen_pays_7month_ago]
      @product_data["UsenPay2023年8月以降"] = [@usen_pays_8month_since]
        
    end 

end
