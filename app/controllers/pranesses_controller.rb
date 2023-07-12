class PranessesController < ApplicationController
  before_action :set_data
  def index 
    @q = Praness.ransack(params[:q])
    @pranesses = 
      if params[:q].nil?
        Praness.none 
      else
        @q.result(distinct: false)
      end
      @pranesses_data = @pranesses.page(params[:page]).per(100)
  end 


  def import 
    if params[:file].present?
      if Praness.csv_check(params[:file]).present?
        redirect_to pranesses_path , alert: "エラーが発生したため中断しました#{Praness.csv_check(params[:file])}"
      else
        message = Praness.import(params[:file]) 
        redirect_to pranesses_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to pranesses_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def new 
    @praness = Praness.new 
    @users = User.where.not(position: "退職")
    
  end 
  
  def create 
    @users = User.where.not(position: "退職")
    @praness = Praness.new(praness_params)
    if @praness.save 
      redirect_to praness_path(@praness.id)
    else  
      render :new
    end 
  end 
  
  def edit 
    @users = User.where.not(position: "退職")
    @praness = Praness.find(params[:id])
  end 
  
  def update 
    @users = User.where.not(position: "退職")
    @praness = Praness.find(params[:id])
    @praness.update(praness_params)
      redirect_to praness_path(@praness.id)
  end 

  def show 
    @praness = Praness.find(params[:id])
  end 

  def simplified_chart 
    @pranesses_year = Praness.includes(:user).where(date: @month.all_year)
  end 

  def not_payment 
    
  end 

 

  private 
  def praness_params 
    params.require(:praness).permit(
      :store_name,
      :customer_num,
      :user_id,
      :date,
      :status,
      :cash_status,
      :terminal_num,
      :remarks,
      :sales_man_remarks,
      :terminal_status,
      :ssid_1,
      :ssid_2,
      :pass_1,
      :pass_2,
      :cancel,
      :cancel_reason,
      :ssid_pass_change,
      :start,
      :payment_start,
      :first_payment,
      :aplus_num,
      :cash_name,
      :payment_terminal,
      :not_use_reason,
      :done,
      :option,
      :mail,
      :notice_send,
      :def_remarks,
      :status_update,
    )
  end 

  def set_data
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
  end 

end
