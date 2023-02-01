class SummitClientsController < ApplicationController

  def import 
    if params[:file].present?
      if SummitClient.csv_check(params[:file]).present?
        redirect_to summits_path , alert: "エラーが発生したため中断しました#{SummitClient.csv_check(params[:file])}"
      else
        message = SummitClient.import(params[:file]) 
        redirect_to summits_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to summits_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def all_delete
    SummitClient.destroy_all
    redirect_to summits_path, alert: "クライアント情報を全て削除しました。"
  end 
end
