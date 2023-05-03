class PaymentPranessesController < ApplicationController

  def index 
    @q = PaymentPraness.ransack(params[:q])
    @payment_pranesses = 
      if params[:q].nil?
        PaymentPraness.none 
      else
        @q.result(distinct: false)
      end
      @payment_pranesses_data = @payment_pranesses.page(params[:page]).per(100)
  end 

  def year_profit
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @payment_pranesses = PaymentPraness.includes(:praness).where.not(payment_method: "請求しない").where("payment_date LIKE ?","%#{@month.year}%").order(:payment_date)
    @pranesses = Praness.all
    # 入金待ち
    @waiting_for_payment = 
    PaymentPraness.where(payment_method: nil).where("payment_date LIKE ?","%#{@month.year}%").where(status: "結果待ち")
      .or(
        PaymentPraness.where(payment_method: "直接請求").where.not(status: "完了").where("payment_date LIKE ?","%#{@month.year}%").where(payment_schedule: Date.today..)
      )
  end


  def import 
    if params[:file].present?
      if PaymentPraness.csv_check(params[:file]).present?
        redirect_to payment_pranesses_path , alert: "エラーが発生したため中断しました#{PaymentPraness.csv_check(params[:file])}"
      else
        message = PaymentPraness.import(params[:file]) 
        redirect_to payment_pranesses_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to payment_pranesses_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 
  
end
