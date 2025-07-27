class BaselineMetricsController < ApplicationController
  def new
    @baseline_sale = BaselineSale.find(params[:baseline_sale_id])
    @metric_name = params[:metric_name]
    @baseline_metric = BaselineMetric.new

  end

  def create
    @baseline_metric = BaselineMetric.new(baseline_metric_params)
    if @baseline_metric.save
      redirect_to calc_periods_path, alert: "目標売上の#{@baseline_metric.metric_name}を追加いたしました。"
    else
      render :new 
    end

  end

  def edit
    @baseline_sale = BaselineSale.find(params[:baseline_sale_id])
    @baseline_metric = @baseline_sale.baseline_metrics.find(params[:id])
  end

  def update
    @baseline_sale = BaselineSale.find(params[:baseline_sale_id])
    @baseline_metric = @baseline_sale.baseline_metrics.find(params[:id])

    if @baseline_metric.update(baseline_metric_params)
      redirect_to calc_periods_path, alert: "目標売上の基準値#{@baseline_metric.metric_name}を更新いたしました。"
    else
      render :edit
    end
  end

  private

  def baseline_metric_params 
    params.require(:baseline_metric).permit(:baseline_sale_id, :metric_name, :metric_val, :metric_per)
  end
end
