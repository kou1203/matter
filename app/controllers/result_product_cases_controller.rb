class ResultProductCasesController < ApplicationController
  include CommonCalc
  before_action :set_common_params
  before_action :set_base_params, exept: :show
  def index 
  end 

  def case_standard_val 
    render partial: "case_standard_val", locals: {} # を遅延ロード
  end 
  def case_out 
    render partial: "case_out", locals: {} # を遅延ロード
  end 
  def case_productivity 
    render partial: "case_productivity", locals: {} # を遅延ロード
  end 

  def show 
    @user = User.params[:id]
  end 

  private

  def set_common_params
    calc_valuation
    @shift_case = params[:shift_case]
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @results = Result.includes(:user, :result_cash).where(date: @start_date..@end_date)
    if @shift_case.present?
      @results = @results.where(product: @shift_case)
    end 
    @shifts = Shift.where(start_time: @start_date..@end_date)
    @shifts = @shifts.where(shift: "キャッシュレス新規").or(
      @shifts.where(shift: "キャッシュレス決済")
    )
  end 

  def set_base_params
    @base = params[:base]
    @results_base = @results.where(user: {base: @base})
    @users = User.where.not(position: "退職").where(base_sub: "キャッシュレス").where(base: @base)
  end 
end
