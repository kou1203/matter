class DisplayPeriodsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @results = Result.where(date: @month.prev_month.beginning_of_month.since(25.days)..@month.beginning_of_month.since(24.days))
    @minimum_result_cash = @results.minimum(:date)
    @maximum_result_cash = @results.maximum(:date)
    @cash_result = Result.includes(:user).joins(:user).where(date: @minimum_result_cash..@maximum_result_cash)
    @minimum_date_cash = @month.prev_month.beginning_of_month.since(25.days)
    @maximum_date_cash = @month.beginning_of_month.since(24.days)
    @dmers = Dmer.where(date: @minimum_date_cash..@maximum_date_cash)
    @aupays = Aupay.where(date: @minimum_date_cash..@maximum_date_cash)
    @rakuten_pays = RakutenPay.where(date: @minimum_date_cash..@maximum_date_cash)
    @airpays = Airpay.where(date: @minimum_date_cash..@maximum_date_cash)
    @dmers_rank = {}
    @dmers.group(:user_id).each do |dmer| 
      @dmers_rank.store(dmer.user.name,@dmers.where(user_id: dmer.user_id).length)
    end 
    @dmers_rank = @dmers_rank.sort {|(k1,v1), (k2,v2)| v2<=>v1}.to_h
    @aupays_rank = {}
    @aupays.group(:user_id).each do |aupay| 
      @aupays_rank.store(aupay.user.name,@aupays.where(user_id: aupay.user_id).length)
    end 
    @aupays_rank = @aupays_rank.sort {|(k1,v1), (k2,v2)| v2<=>v1}.to_h
    @rakuten_pays_rank = {}
    @rakuten_pays.group(:user_id).each do |rakuten_pay| 
      @rakuten_pays_rank.store(rakuten_pay.user.name,@rakuten_pays.where(user_id: rakuten_pay.user_id).length)
    end 
    @rakuten_pays_rank = @rakuten_pays_rank.sort {|(k1,v1), (k2,v2)| v2<=>v1}.to_h
    @airpays_rank = {}
    @airpays.group(:user_id).each do |airpay| 
      @airpays_rank.store(airpay.user.name,@airpays.where(user_id: airpay.user_id).length)
    end 
    @airpays_rank = @airpays_rank.sort {|(k1,v1), (k2,v2)| v2<=>v1}.to_h
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

  def cost_params 
    params.require(:cost).permit(
       :year                            ,
       :month                           ,
       :base                            ,
       :group                           ,
       :sales_man                       ,
       :office_worker                   ,
       :administrator                   ,
       :social_insurance                ,
       :sales_man_cost                  ,
       :office_worker_cost              ,
       :office                          ,
       :dorm                            ,
       :utility_net_cost                ,
       :bonus_stock                     ,
       :travel_stock                    ,
       :other                           ,
       :update_date
    )
  end
end
