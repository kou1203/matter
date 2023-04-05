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
