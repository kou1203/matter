class StocksController < ApplicationController

  def index 
    @stocks = Stock.all
  end 

  def import 
    Stock.import(params[:file])
    redirect_to root_path
  end 

end
