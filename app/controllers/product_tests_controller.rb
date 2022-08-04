class ProductTestsController < ApplicationController
  def index
    @users = User.all
    @user = User.find(5)
    @shift = Shift.where(user_id: @user.id)
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today
    @minimum_date_cash = @month.prev_month.beginning_of_month.since(25.days)
    @maximum_date_cash = @month.beginning_of_month.since(24.days)
    @results = Result.where(date: @minimum_date_cash..@maximum_date_cash).order(:date)
    @visit_items_chubu = @results.includes(:user).where(user: {base: "中部SS"})
    @visit_items_kansai = @results.includes(:user).where(user: {base: "関西SS"})
    @visit_items_kanto = @results.includes(:user).where(user: {base: "関東SS"})

    @minimum_date_cash = @month.prev_month.beginning_of_month.since(25.days)
    @maximum_date_cash = @month.beginning_of_month.since(24.days)
    # 拠点別resultデータ
    @results_chubu = 
      Result.includes(:user)
      .where(user: {base: "中部SS"})
      .where(user: {base_sub: "キャッシュレス"})
      .where(date: @minimum_date_cash..@maximum_date_cash).order(:date)
    @results_kanto = 
      Result.includes(:user)
      .where(user: {base: "関東SS"})
      .where(user: {base_sub: "キャッシュレス"})
      .where(date: @minimum_date_cash..@maximum_date_cash).order(:date)
    @results_kansai = 
      Result.includes(:user)
      .where(user: {base: "関西SS"})
      .where(user: {base_sub: "キャッシュレス"})
      .where(date: @minimum_date_cash..@maximum_date_cash).order(:date)
    # 拠点別新規消化シフト
    @shift_digestion_chubu = @results_chubu.where(shift: "キャッシュレス新規").length
    @shift_digestion_kansai = @results_kansai.where(shift: "キャッシュレス新規").length
    @shift_digestion_kanto = @results_kanto.where(shift: "キャッシュレス新規").length
  end
end
