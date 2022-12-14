class CalcPeriodsController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @calc_periods = CalcPeriod.all
    @calc_periods_val = CalcPeriod.where(sales_category: "評価売")
    @calc_periods_prof = CalcPeriod.where(sales_category: "実売")
    @dmer_date_progresses = DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
    @dmer_date_progresses_last_update = @dmer_date_progresses.maximum(:create_date)
  end 

  def new 
    @calc_period = CalcPeriod.new 
  end 

  def create 
    @calc_period = CalcPeriod.new (calc_period_params)
    @calc_period[:this_month_per] = @calc_period.this_month_per.to_f / 100
    @calc_period[:prev_month_per] = @calc_period.prev_month_per.to_f / 100
    if @calc_period.save
      redirect_to calc_periods_path, alert: "成果期間を新しく追加しました。"
    else 
      render :new, alert: "入力されていない項目があります。入力をお願いします。"
    end 
  end 

  def edit 
    @calc_period = CalcPeriod.find(params[:id])
    @calc_period[:this_month_per] = (@calc_period.this_month_per * 100).to_i
    @calc_period[:prev_month_per] = (@calc_period.prev_month_per * 100).to_i
  end 

  def update 
    @calc_period = CalcPeriod.find(params[:id])
    @calc_period.update(calc_period_params)
    @calc_period.update(set_percent_params)
    redirect_to calc_periods_path, alert: "#{@calc_period.name}の内容を更新しました。"

  end 

  private 
  def calc_period_params 
    params.require(:calc_period).permit(
      :name                                           ,
      :sales_category                                 ,
      # 獲得期間
      :start_date_month                               ,
      :start_date_day                                 ,
      :end_date_month                                 ,
      :end_date_day                                   ,
      # 審査完了期間
      :start_done_month                               ,
      :start_done_day                                 ,
      :end_done_month                                 ,
      :end_done_day                                   ,
      # 締め日
      :closing_date_month                             ,
      :closing_date_day                               ,
      # パーセント
      :this_month_per                                 ,
      :prev_month_per                                 ,
      # 終着単価
      :price                                          ,
      :bonus1_len                                     ,
      :bonus2_len                                     ,
      :bonus1_price                                   ,
      :bonus2_price                                   ,
    )
  end 

  def calc_period_edit_params 
    params.require(:calc_period).permit(
      :name                                           ,
      :sales_category                                 ,
      # 獲得期間
      :start_date_month                               ,
      :start_date_day                                 ,
      :end_date_month                                 ,
      :end_date_day                                   ,
      # 締め日
      :closing_date_month                             ,
      :closing_date_day                               ,
      :price                                          ,
    )
  end 

  # パーセントを / 100 してFloat値にする ex) 60 => 0.6, set_month_per_floatはmodelにて格納されている
  def set_percent_params
    calc_period_edit_params.merge(@calc_period.set_month_per_float)
  end 
end
