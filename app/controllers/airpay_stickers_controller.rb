class AirpayStickersController < ApplicationController

  def index 
    @q = AirpaySticker.includes(:user).ransack(params[:q])
    @airpays = 
      if params[:q].nil?
        AirpaySticker.none 
      else 
        @q.result(distinct: false)
      end
      @airpays_data = @airpays.page(params[:page]).per(100)
  end 

  def import
    if params[:file].present?
      message = AirpaySticker.import(params[:file]) 
      redirect_to airpay_stickers_path, alert: "インポート処理を完了しました#{message}"
    else
      redirect_to airpay_stickers_path, alert: "インポートに失敗しました。ファイルの中身に問題ないか確認してください。"
    end
  end 



end
