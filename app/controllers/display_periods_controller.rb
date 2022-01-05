class DisplayPeriodsController < ApplicationController

  def index 
    @display_period = DisplayPeriod.new
    @display_period_1 = DisplayPeriod.first if DisplayPeriod.first.present?
    @results = Result.all
    if   DisplayPeriod.all.length != 0
    end
        @dmers = Dmer.all.includes(:user)
        @aupays = Aupay.all.includes(:user)
        @paypays = Paypay.all.includes(:user)
        @rakuten_pays = RakutenPay.all.includes(:user)
        @st_insurances = StInsurance.all.includes(:user)
        @rakuten_casas = RakutenCasa.all.includes(:user)
        @users = User.all.includes(:results).includes(:shifts)
        @cash_results = Result.all.includes(:user).where(date: @display_period_1.start_period_01..@display_period_1.end_period_01)
        @cash_results_prev = Result.all.includes(:user).where(date: @display_period_1.start_period_01..@display_period_1.end_period_01.ago(7.days))
        @cash_shifts = Shift.all.includes(:user).where(start_time: @display_period_1.start_period_01..@display_period_1.end_period_01)

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
end
