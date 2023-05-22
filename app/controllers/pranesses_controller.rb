class PranessesController < ApplicationController
  require 'csv'

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
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @pranesses_year = Praness.where(date: @month.all_year)
    
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

  def send_pranesses_csv(pranesses)
    csv_data = CSV.generate do |csv|
      column_names = %w(user store_prop stock get_date ssid_change ssid_1 ssid_2 pass_1 pass_2 cancel return_remarks remarks claim start deadline withdrawal payment)
      csv << column_names
      pranesses.each do |praness|
        column_values = [
          praness.user.name,
          praness.store_prop.name,
          praness.stock.stock_num,
          praness.get_date,
          praness.ssid_change,
          praness.ssid_1,
          praness.pass_1,
          praness.ssid_2,
          praness.pass_2,
          praness.cancel,
          praness.return_remarks,
          praness.remarks,
          praness.claim,
          praness.start,
          praness.deadline,
          praness.payment

        ]
        csv << column_values
      end 
    end 
    send_data(csv_data, filename: "ぷらねす.csv")
  end 

end
