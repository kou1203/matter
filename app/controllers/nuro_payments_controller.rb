class NuroPaymentsController < ApplicationController

  def index 
    @q = NuroPayment.includes(:nuro).ransack(params[:q])
    @nuro_payments = 
      if params[:q].nil?
        NuroPayment.none 
      else
        @q.result(distinct: false)
      end
      @nuro_managemenet_fees = NuroManagemenetFee.all
      @nuro_payments_data = @nuro_payments.page(params[:page]).per(100)
      session[:previous_url] = request.referer
  end 

  def import
    if params[:file].present?
      # if Airpay.csv_check(params[:file]).present?
      #   redirect_to airpays_path , alert: "エラーが発生したため中断しました#{Airpay.csv_check(params[:file])}"
      # else
      message = NuroPayment.import(params[:file]) 
      redirect_to nuro_payments_path, alert: "インポート処理を完了しました#{message}"
      # end
    else
      redirect_to nuro_payments_path, alert: "インポートに失敗しました。ファイルの中身に問題ないか確認してください。"
    end
  end 

  def import_managemenet_fee
    if params[:file].present?
      # if Airpay.csv_check(params[:file]).present?
      #   redirect_to airpays_path , alert: "エラーが発生したため中断しました#{Airpay.csv_check(params[:file])}"
      # else
      message = NuroManagemenetFee.import(params[:file]) 
      redirect_to nuro_payments_path, alert: "インポート処理を完了しました#{message}"
      # end
    else
      redirect_to nuro_payments_path, alert: "インポートに失敗しました。ファイルの中身に問題ないか確認してください。"
    end
  end 
end
