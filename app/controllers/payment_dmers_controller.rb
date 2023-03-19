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
    @client = params[:client]
    if @client.present? 
      @payments_monthly = PaymentDmer.where("client LIKE ?","%#{@client}%").where(payment: @month.beginning_of_month..@month.end_of_month)
    else  
      @payments_monthly = PaymentDmer.where(payment: @month.beginning_of_month..@month.end_of_month)
    end 
    @billing_slmt = @payments_monthly.where(result_category: "獲得手数料・初回決済手数料")
    @billing_pic = @payments_monthly.where(result_category: "ステッカー連携手数料")
    @billing_slmt2nd = @payments_monthly.where(result_category: "2回目決済手数料")
    @billing_sticker = @payments_monthly.where(result_category: "事前QR申込インセンティブ")
    # 自社dメル
    @prev_month = @month.ago(1.month) 
    @prev_2month = @month.ago(2.month) 
    if @client.present?
      @dmers = Dmer.includes(:user).where("client LIKE ?","%#{@client}%")
    else  
      @dmers = Dmer.includes(:user)
    end 
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
      # 過去発行済の明細
      @payment_prev = 
        PaymentDmer.includes(:dmer).where.not(payment: @month.beginning_of_month..@month.end_of_month)
        .where(dmer:{ status: "審査OK"}).where.not(dmer: {industry_status: "NG"})
        .where.not(dmer: {industry_status: "×"}).where.not(dmer: {industry_status: "要確認"})
      @payment1_prev = 
        @payment_prev.where(dmer: {result_point: @prev_month.beginning_of_month..@prev_month.end_of_month})
        .where(dmer: {settlement_deadline: @prev_month.beginning_of_month..}).where(result_category: "獲得手数料・初回決済手数料")
        @payment2_prev = 
          @payment_prev.where(dmer: {status_update_settlement: @prev_month.beginning_of_month..@prev_month.end_of_month})
          .where( dmer:{status_settlement: "完了"}).where(result_category: "ステッカー連携手数料")

          @payment3_prev = 
            @payment_prev
            .where(dmer: {status_update_settlement: @prev_2month.beginning_of_month..@prev_2month.end_of_month})
            .where(dmer: {settlement_second: ..@prev_2month.end_of_month})
            .where(dmer: {status_settlement: "完了"}).where(result_category: "2回目決済手数料")
            .or(
              @payment_prev
              .where(dmer: {settlement_second: @prev_2month.beginning_of_month..@prev_2month.end_of_month})
              .where(dmer: {status_update_settlement: ...@prev_2month.end_of_month})
              .where(dmer: {status_settlement: "完了"}).where(result_category: "2回目決済手数料")

            )
        # 過去成果の明細
        @result_prev = PaymentDmer.where(payment: @month.beginning_of_month..@month.end_of_month)
        @result_prev1 = 
          @result_prev.where(result_point: @prev_2month.beginning_of_month..@prev_2month.end_of_month)
          .where(settlement: @prev_2month.beginning_of_month..@prev_2month.end_of_month)
          .where(result_category: "獲得手数料・初回決済手数料")
          .or(
            @result_prev.where(result_point: ..@prev_2month.end_of_month)
            .where(settlement: @prev_2month.beginning_of_month..@prev_2month.end_of_month)
            .where(result_category: "獲得手数料・初回決済手数料")

          )
        @result_prev2 = 
          @result_prev.where(picture_done: @prev_2month.beginning_of_month..@prev_2month.end_of_month)
          .where(result_category: "ステッカー連携手数料")
        
        settlement_second_done = "#{@prev_2month.year}年#{@prev_2month.month}月完了"
        @result_prev3 = 
          @result_prev.where(settlement_second: settlement_second_done)
          .where(picture_done: ..@prev_2month.prev_month.end_of_month)
          .where(result_category: "2回目決済手数料")
          .or(
            @result_prev.where.not(settlement_second: settlement_second_done)
            .where(picture_done: @prev_2month.beginning_of_month..@prev_2month.prev_month.end_of_month)
            .where(result_category: "2回目決済手数料")

          )

        # 来月成果
        @result_next = PaymentDmer.where(payment: @month.beginning_of_month..@month.end_of_month)
        @result_next1 = 
        @result_next.where(result_point: @month.beginning_of_month..)
        .where(settlement: @month.beginning_of_month..@month.end_of_month)
        .where(result_category: "獲得手数料・初回決済手数料")
        .or(
          @result_next.where(result_point: ..@month.end_of_month)
          .where(settlement: @month.beginning_of_month..)
          .where(result_category: "獲得手数料・初回決済手数料")

        )

        @result_next2 = 
          @result_next.where(picture_done: @month.beginning_of_month..)
          .where(result_category: "ステッカー連携手数料")

          settlement_second_done_next = "#{@prev_month.year}年#{@prev_month.month}月完了"
          @result_next3 = 
          @result_next.where(settlement_second: settlement_second_done_next)
          .where(picture_done: ..@prev_month.end_of_month)
          .where(result_category: "2回目決済手数料")
          .or(
            @result_next.where.not(settlement_second: settlement_second_done_next)
            .where(picture_done: @prev_month.beginning_of_month..@prev_month.prev_month.end_of_month)
            .where(result_category: "2回目決済手数料")

          )


       @error_p = @payments_monthly.includes(:dmer).where(dmer: {id: nil}).order(:result_category)
       


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
