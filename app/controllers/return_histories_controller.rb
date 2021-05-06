class ReturnHistoriesController < ApplicationController

  def new 
    @return_history = ReturnHistory.new
    @users = User.all
    @stocks = Stock.all
    @stock = Stock.find(params[:stock_id])
  end 

  def create 
    @stock = Stock.find(params[:stock_id])
    @return_history = ReturnHistory.new(return_history_params)
    if @return_history.save 
      redirect_to stocks_path
    else  
      render :new 
    end 
  end 

  def destroy 
    @return_history = ReturnHistory.find(params[:id])
    @return_history.destroy
    redirect_to stocks_path
  end 

  private 

  def return_history_params
    params.require(:return_history).permit(
      :user_id, :stock_id, :return
    )
  end 


end
