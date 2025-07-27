class BaselineSalesController < ApplicationController

  def new
    @baseline_sale = BaselineSale.new
  end

  def create
    @baseline_sale = BaselineSale.new(baseline_sale_params)
    if @baseline_sale.save
      redirect_to calc_periods_path, alert: "目標売上を追加いたしました。"
    else
      render :new 
    end
  end

  def edit
    @baseline_sale = BaselineSale.find(params[:id])
  end

  def update
    @baseline_sale = BaselineSale.find(params[:id])
    @baseline_sale.update(baseline_sale_params)
    redirect_to calc_periods_path, alert: "目標売上を更新いたしました。"
  end

  private

  def baseline_sale_params 
    params.require(:baseline_sale).permit(:sales_goal)
  end

end
