class PaymentDmersController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today.prev_month
    @q = Paypay.ransack(params[:q])
    @payments = 
      if params[:q].nil?
        Paypay.none 
      else
        @q.result(distinct: false)
      end
      @payments_data = @payments.page(params[:page]).per(100)
      @payments_monthly = PaymentDmer.where(payment: @month.beginning_of_month..@month.end_of_month)

      # 自社dメル
      @prev_month = @month.ago(1.month) 
      @prev_2month = @month.ago(2.month) 
      @dmer_result1 = 
        Dmer.where(result_point: @prev_month.beginning_of_month..@prev_month.end_of_month)
        .where(settlement_deadline: @prev_month.beginning_of_month..)
        .where(settlement: ..@prev_month.end_of_month)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .or(
          Dmer.where(settlement: @prev_month.beginning_of_month..@prev_month.end_of_month)
          .where(settlement_deadline: @prev_month.beginning_of_month..)
          .where(result_point: ..@prev_month.end_of_month)
          .where(status: "審査OK")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
        )
      
        @dmer_result2 = 
          Dmer.where(status_update_settlement: @prev_month.beginning_of_month..@prev_month.end_of_month)
          .where(status: "審査OK")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status_settlement: "完了")
      
        @dmer_result3 = 
          Dmer.where(status_update_settlement: @prev_2month.beginning_of_month..@prev_2month.end_of_month)
          .where(settlement_second: ..@prev_2month.end_of_month)
          .where(status: "審査OK")
          .where.not(industry_status: "NG")
          .where.not(industry_status: "×")
          .where.not(industry_status: "要確認")
          .where(status_settlement: "完了")
          .or(
            Dmer.where(settlement_second: @prev_2month.beginning_of_month..@prev_2month.end_of_month)
            .where(status_update_settlement: ..@prev_2month.end_of_month)
            .where(status: "審査OK")
            .where.not(industry_status: "NG")
            .where.not(industry_status: "×")
            .where.not(industry_status: "要確認")
            .where(status_settlement: "完了")

          )
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
