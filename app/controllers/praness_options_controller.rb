class PranessOptionsController < ApplicationController

  def index 
    @q = PranessOption.ransack(params[:q])
    @praness_options = 
      if params[:q].nil?
        PranessOption.none 
      else
        @q.result(distinct: false)
      end
      @praness_options_data = @praness_options.page(params[:page]).per(100)
  end 

  def import
    if params[:file].present?
      if PranessOption.csv_check(params[:file]).present?
        redirect_to praness_options_path , alert: "エラーが発生したため中断しました#{PranessOption.csv_check(params[:file])}"
      else
        message = PranessOption.import(params[:file]) 
        redirect_to praness_options_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to praness_options_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 


  private
end
