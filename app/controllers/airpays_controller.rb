class AirpaysController < ApplicationController
  before_action :authenticate_user!
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

  def new 
    @users = User.where.not(position: "退職")
    @store_prop = StoreProp.find(params[:store_prop_id])
    @airpay = Airpay.new()
  end 

  def create 
    @airpay = Airpay.new(airpay_params)
    @store_prop = @airpay.store_prop_id
    @airpay.save
    if @airpay.save
      redirect_to store_prop_path(@store_prop)
    else  
      render :new
    end 
  end 

  def edit 
    @airpay = Airpay.find(params[:id])
    @users = User.where.not(position: "退職")
  end 

  def update 
    @airpay = Airpay.find(params[:id])
    @airpay.update(airpay_params)
    redirect_to airpay_path(@airpay.id)
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

  # 早見
  def simple_conf
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @bases = ["中部SS", "関西SS", "関東SS", "九州SS", "2次店"]
    @airpays = Airpay.includes(:user).where(date: @month.all_month)
  end 

  private 
  def airpay_params
    params.require(:airpay).permit(
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
