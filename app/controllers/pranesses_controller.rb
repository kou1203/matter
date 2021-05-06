class PranessesController < ApplicationController

  def index 
    @pranesses = Praness.all
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
      :remarks, :claim, :start, :deadline, :withdrawal,:payment 
    )
  end 

end
