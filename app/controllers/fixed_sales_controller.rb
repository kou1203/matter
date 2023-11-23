class FixedSalesController < ApplicationController
  before_action :set_month

  def index 
    @fixed_sales = FixedSale.where(date: @month.all_month)
  end 

  def new 
    @fixed_sale = FixedSale.new
  end

  def create 
    @fixed_sale = FixedSale.new(fixed_sale_params)
    @fixed_sale.save
    if @fixed_sale.save
      redirect_to fixed_sales_path, alert: "#{@fixed_sale.base}：#{@fixed_sale.name}の固定費を登録しました。" 
    else  
      render :new
    end

    def edit 
      @fixed_sale = FixedSale.find(params[:id])
    end 

    def update 
      @fixed_sale = FixedSale.find(params[:id])
      @fixed_sale.update(fixed_sale_params)
      redirect_to fixed_sales_path, alert: "#{@fixed_sale.base}：#{@fixed_sale.name}の固定費を編集しました。" 

    end 

  end 

  private
  def set_month 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
  end 
  def fixed_sale_params
    params.require(:fixed_sale).permit(:name,:base,:date,:price,)
  end 
end
