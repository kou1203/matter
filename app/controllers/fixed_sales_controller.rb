class FixedSalesController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @fixed_sales = FixedSale.where(date: @month.all_month)
  end 

end
