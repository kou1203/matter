class StockHistoriesController < ApplicationController

  def new 
    @stock_history = StockHistory.new
    @users = User.all
    @stocks = Stock.all
    @stock = Stock.find(params[:stock_id])
  end 

  def create 
    @stock = Stock.find(params[:stock_id])
    @stock_history = StockHistory.new(stock_history_params)
    if @stock_history.save 
      redirect_to stocks_path
    else  
      render :new 
    end 
  end 

  def show 

    @stock_history = StockHistory.new(stock_history_params)
    if @stock_history.save 
      redirect_to stocks_path
    else  
      render :new 
    end 
  end 

  def destroy 
    @stock_history = StockHistory.find(params[:id])
    @stock_history.destroy 
    redirect_to stocks_path
  end 
  private 

  def stock_history_params
    params.require(:stock_history).permit(
      :user_id, :stock_id, :take_out
    )
  end 

end
