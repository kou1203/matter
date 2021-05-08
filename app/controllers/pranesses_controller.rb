class PranessesController < ApplicationController
  require 'csv'

  def index 
    @q = Praness.ransack(params[:q])
    @pranesses = @q.result(distinct: true)
    respond_to do |format|
      format.html
      format.csv do |csv|
        send_pranesses_csv(@pranesses)
      end 
    end
  end 

  def new 
    @praness = Praness.new 
    @users = User.all
    @store_prop = StoreProp.find(params[:store_prop_id])
    @stocks = Stock.all
  end 
  
  def create 
    @stocks = Stock.all
    @users = User.all
    @store_prop = StoreProp.find(params[:store_prop_id])
    @praness = Praness.new(praness_params)
    if @praness.save 
      redirect_to  pranesses_path
    else  
      render :new
    end 
  end 

  def import 
    Praness.import(params[:file])
    redirect_to pranesses_path
  end 

  def edit 
    @users = User.all
    @stocks = Stock.all
    @praness = Praness.find(params[:id])
  end 
  
  def update 
    @praness = Praness.find(params[:id])
    @praness.update(praness_params)
    redirect_to praness_path(@praness.id)
  end 

  def show 
    @praness = Praness.find(params[:id])
  end 

 

  private 
  def praness_params 
    params.require(:praness).permit(
      :user_id, :store_prop_id,:stock_id, :get_date, :ssid_change, :ssid_1,
      :ssid_2, :pass_1, :pass_2, :cancel, :return_remarks,
      :remarks, :claim, :start, :deadline, :withdrawal,:payment,
      :client 
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
          praness.withdrawal,
          praness.payment

        ]
        csv << column_values
      end 
    end 
    send_data(csv_data, filename: "ぷらねす.csv")
  end 

end
