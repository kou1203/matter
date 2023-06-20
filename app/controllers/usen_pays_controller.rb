class UsenPaysController < ApplicationController

  def index 
    @q = UsenPay.includes(:user).ransack(params[:q])
    @usen_pays = 
      if params[:q].nil?
        UsenPay.none 
      else 
        @q.result(distinct: false)
      end
      @usen_pays_data = @usen_pays.page(params[:page]).per(100)
  end  

  def import 
    if params[:file].present?
      if UsenPay.csv_check(params[:file]).present?
        redirect_to usen_pays_path , alert: "エラーが発生したため中断しました#{UsenPay.csv_check(params[:file])}"
      else
        message = UsenPay.import(params[:file]) 
        redirect_to usen_pays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to usen_pays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  private 
end
