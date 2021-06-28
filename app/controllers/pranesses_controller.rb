class PranessesController < ApplicationController
  require 'csv'

  def index 
    @q = Praness.ransack(params[:q])
    @pranesses = 
      if params[:q].nil?
        Praness.none 
      else  
        @q.result(distinct: true)
      end
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
    stock_table = Stock.arel_table
    @stocks = Stock.joins('LEFT JOIN stock_histories ON stocks.id = stock_histories.stock_id').where('stock_histories.id IS NOT NULL')
    
  end 
  
  def create 
    @stocks = Stock.joins('LEFT JOIN stock_histories ON stocks.id = stock_histories.stock_id').where('stock_histories.id IS NOT NULL')
    @users = User.all
    @store_prop = StoreProp.find(params[:store_prop_id])
    @praness = Praness.new(praness_params)
    if @praness.save 
      redirect_to store_prop_path(@store_prop.id)
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
    @stocks = Stock.joins('LEFT JOIN stock_histories ON stocks.id = stock_histories.stock_id').where('stock_histories.id IS NOT NULL')
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
      :customer_num,
      :client,
      :user_id,
      :store_prop_id,
      :get_date,
      :payment,
      :status,
      :stock_id,
      :ssid_change,
      :ssid_1,
      :pass_1,
      :ssid_2,
      :pass_2,
      :cancel,
      :return_remarks,
      :remarks,
      :claim,
      :start,
      :deadline
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
