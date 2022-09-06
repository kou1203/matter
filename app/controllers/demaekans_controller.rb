class DemaekansController < ApplicationController

  def index 
    @q = Demaekan.includes(:user).ransack(params[:q])
    @demaekans = 
      if params[:q].nil?
        Demaekan.none 
      else 
        @q.result(distinct: false)
      end
      @demaekans_data = @demaekans.page(params[:page]).per(100)
  end 

  def import 
    if params[:file].present?
      if Aupay.csv_check(params[:file]).present?
        redirect_to aupays_path , alert: "エラーが発生したため中断しました#{Aupay.csv_check(params[:file])}"
      else
        message = Aupay.import(params[:file]) 
        redirect_to aupays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to aupays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

end
