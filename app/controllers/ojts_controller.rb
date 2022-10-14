class OjtsController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @start_date = @month.prev_month.beginning_of_month.since(25.days)
    @end_date = @month.beginning_of_month.since(24.days)
    @ojts = Result.includes(:user).where.not(ojt_id: nil).where(date: @start_date..@end_date).order(date: "ASC")
  end 

  def show 
    @ojt_date = Result.find(params[:result_id])
    @ojt_before = Result.includes(:user,:result_cash).where(user_id: @ojt_date.user_id).where("? > date",@ojt_date.date)
    @ojt_before = @ojt_before.last(3)
    @ojt_after = Result.where(user_id: @ojt_date.user_id).where("? < date",@ojt_date.date)
    @ojt_after = @ojt_after.first(3)
    @ojt_data = 
      Result.where(user_id: @ojt_date.user_id).where(date: @ojt_date.date.ago(3.days)..@ojt_date.date.since(3.days))
      .where(shift: "キャッシュレス新規")

  end 
end
