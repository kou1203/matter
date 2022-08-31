class DmerStocksController < ApplicationController

  def index 
    @dmer_stocks = DmerStock.all.page(params[:page]).per(100)
  end 

  def new
    @dmer_stock = DmerStock.new
  end 

  def create
    @dmer_stock = DmerStock.new(stock_params)
    if @dmer_stock.save 
      redirect_to dmer_stocks_path
    else  
      render :new 
    end 
  end 

  def edit 
    @dmer_stock = DmerStock.find(params[:id])

  end
  
  def update 
    @dmer_stock = DmerStock.find(params[:id])
    @dmer_stock.update(stock_params)
    redirect_to dmer_stocks_path
  end 


  private 
  def stock_params 
    params.require(:dmer_stock).permit(
      :date,
      :base,
      :client,
      :stock_len
    )
  end 
  
end
