class SummitErrorHistoriesController < ApplicationController

  def index 
    @q = SummitErrorHistory.includes(:user).ransack(params[:q])
    @summit_errors = 
      if params[:q].nil?
        SummitErrorHistory.none 
      else 
        @q.result(distinct: false)
      end
      @summit_errors_data = @summit_errors.page(params[:page]).per(100)
      @users = User.where(base_sub: "サミット")
  end 

  def show 
    @summit_error = SummitErrorHistory.find(params[:id])
    @summit_errors = SummitErrorHistory.where(error_record_num: @summit_error.error_record_num)
  end 

  def import 
    if params[:file].present?
      if SummitErrorHistory.csv_check(params[:file]).present?
        redirect_to summit_error_histories_path , alert: "エラーが発生したため中断しました#{SummitErrorHistory.csv_check(params[:file])}"
      else
        message = SummitErrorHistory.import(params[:file]) 
        redirect_to summit_error_histories_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to summit_error_histories_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 
end
