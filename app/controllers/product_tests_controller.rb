class ProductTestsController < ApplicationController
  def index
    @users = User.all
    @user = User.find(5)
    @shift = Shift.where(user_id: @user.id)
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    @minimum_date_cash = @month.prev_month.beginning_of_month.since(25.days)
    @maximum_date_cash = @month.beginning_of_month.since(24.days)
    @results = Result.where(user_id: @user.id).where(date: @minimum_date_cash..@maximum_date_cash).order(:date)
    
  end
end
