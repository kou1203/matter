class StocksController < ApplicationController

  def index 
    @q = Stock.includes(:praness, :stock_history, :return_history).ransack(params[:q])
    @stocks = @q.result(distinct: true)
  end 

  def new 
    @stock = Stock.new 
  end 

  def create 
    @stock = Stock.new(stock_params)
    @stock.save 
    if @stock.save 
      redirect_to stocks_path 
    else  
      render :new
    end 
  end 

  def edit 
    @stock = Stock.find(params[:id])
  end 
  
  def update 
    @stock = Stock.find(params[:id])
    @stock.update(stock_params)
    redirect_to stocks_path 
  end

  def import 
    Stock.import(params[:file])
    redirect_to stocks_path
  end 

  def destroy 
    @stock = Stock.find(params[:id])
    @stock.destroy
    redirect_to stocks_path
  end 

  private 
  def stock_params 
    params.require(:stock).permit(:stock_num, :mac_num, :status, :mail, :remarks)
  end 

end
