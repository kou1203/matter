class ItssesController < ApplicationController

  def index 
    @q = Itss.ransack(params[:q])
    @itsses = 
      if params[:q].nil?
        Itss.none 
      else
        @q.result(distinct: false)
      end
      @itsses_data = @itsses.page(params[:page]).per(100)
  end 

  def import
    if params[:file].present?
      # if Airpay.csv_check(params[:file]).present?
      #   redirect_to airpays_path , alert: "エラーが発生したため中断しました#{Airpay.csv_check(params[:file])}"
      # else
      message = Itss.import(params[:file]) 
      redirect_to itsses_path, alert: "インポート処理を完了しました#{message}"
      # end
    else
      redirect_to itsses_path, alert: "インポートに失敗しました。ファイルの中身に問題ないか確認してください。"
    end
  end 
end
