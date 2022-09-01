class DmerStocksController < ApplicationController

  def index 
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    @dmer_stocks = DmerStock.where(date: @month.all_month).page(params[:page]).per(100)
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
