class AirpaysController < ApplicationController

  def index 
    @q = Airpay.includes(:user).ransack(params[:q])
    @airpays = 
      if params[:q].nil?
        Airpay.none 
      else 
        @q.result(distinct: false)
      end
      @airpays_data = @airpays.page(params[:page]).per(100)
  end 

  def show 
    @airpay = Airpay.find(params[:id])
  end 

  def import
    if params[:file].present?
      # if Airpay.csv_check(params[:file]).present?
      #   redirect_to airpays_path , alert: "エラーが発生したため中断しました#{Airpay.csv_check(params[:file])}"
      # else
      message = Airpay.import(params[:file]) 
      redirect_to airpays_path, alert: "インポート処理を完了しました#{message}"
      # end
    else
      redirect_to airpays_path, alert: "インポートに失敗しました。ファイルの中身に問題ないか確認してください。"
    end
  end 

  private 
  def airpay_params
    params.require(:aiepay).permit(
      :store_prop_id                    ,
      :user_id                    ,
       :date                   ,  
       :client                 , 
       :status                 , 
       :terminal_status        ,
       :customer_num           , 
       :result_point           ,
       :payment                ,
       :qr_flag              ,
       :ipad_flag              ,
       :doc_follow             ,
       :delivery_status        ,
       :shipping               ,
       :activate               ,
       :valuation              ,
       :profit                 
    )
  end 
end
