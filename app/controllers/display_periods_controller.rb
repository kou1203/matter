class DisplayPeriodsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @display_period = DisplayPeriod.new
    @display_period_1 = DisplayPeriod.first if DisplayPeriod.first.present?
    if @display_period_1.present?
      @cash_results = 
        Result.includes(:user).where(user: {base_sub: "キャッシュレス"})
        .where(date: @display_period_1.start_period_01..@display_period_1.end_period_01)
      @cash_results_chubu = @cash_results.where(user: {base: "中部SS"})
      @cash_results_kansai = @cash_results.where(user: {base: "関西SS"})
      @cash_results_kanto = @cash_results.where(user: {base: "関東SS"})
      @cash_shifts = 
        Shift.includes(:user).where(user: {base_sub: "キャッシュレス"})
        .where(start_time: @display_period_1.start_period_01..@display_period_1.start_period_01.beginning_of_month.since(1.month).since(24.days))
      @cost = Cost.new
      @cost_all = 
        Cost.where(year: @display_period_1.end_period_01.year)
        .where(month: @display_period_1.end_period_01.month)
      @cost_chubu = @cost_all.where(base: "中部キャッシュレス")
      @cost_kansai = @cost_all.where(base: "関西キャッシュレス")
      @cost_kanto = @cost_all.where(base: "関東キャッシュレス")
    end
  end 
  
  def create 
    @display_period = DisplayPeriod.new(display_periods_params)
    if @display_period.save
      flash[:notice] = "申請をしました。"
      redirect_to display_periods_path
    else  
      flash[:notice] = "失敗しました。"
      render :index 
    end 
    @cost = Cost.new(cost_params)
  end 

  def update 
    @display_period_1 = DisplayPeriod.first
    @display_period_1.update(display_periods_params)
    flash[:notice] = "更新しました。"
    redirect_to display_periods_path
  end 

  private

  def display_periods_params
    params.require(:display_period).permit(
      :start_period_01       ,
      :end_period_01         ,
      :start_period_02       ,
      :end_period_02         ,
      :start_period_03       ,
      :end_period_03         ,
      :start_period_04       ,
      :end_period_04         ,
      :start_period_05       ,
      :end_period_05         
    )
  end 

  def cost_params 
    params.require(:cost).permit!
  end
end
