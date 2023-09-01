class NurosController < ApplicationController

  def index 
  end 

  def import
    if params[:file].present?
      # if Airpay.csv_check(params[:file]).present?
      #   redirect_to airpays_path , alert: "エラーが発生したため中断しました#{Airpay.csv_check(params[:file])}"
      # else
      message = Nuro.import(params[:file]) 
      redirect_to nuros_path, alert: "インポート処理を完了しました#{message}"
      # end
    else
      redirect_to nuros_path, alert: "インポートに失敗しました。ファイルの中身に問題ないか確認してください。"
    end
  end
end
