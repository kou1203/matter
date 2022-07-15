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

  def import
    if params[:file].present?
      if Airpay.csv_check(params[:file]).present?
        redirect_to airpays_path , alert: "エラーが発生したため中断しました#{Airpay.csv_check(params[:file])}"
      else
        message = Airpay.import(params[:file]) 
        redirect_to airpays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to airpays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  private 
  def airpay_params
    params.require(:aiepay).permit(
      :store_name              ,
      :user                    ,
       :race                   ,
       :corporate_name         ,
       :date                   ,  
       :status                 , 
       :terminal_status        ,
       :customer_num           , 
       :kr_code                , 
       :result_point           ,
       :payment                ,
       :ipad_flag              ,
       :vm_status              ,
       :vm_status_name         ,
       :doc_follow             ,
       :delivery_status        ,
       :activate               ,
       :valuation              ,
       :profit                 
    )
  end 
end
