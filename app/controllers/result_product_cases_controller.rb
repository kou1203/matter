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
    @user = User.find(params[:user_id])
    @results_person = 
      @results.where(user_id: @user.id).where(shift: "キャッシュレス新規")
    @results_person_slmt = 
      @results.where(user_id: @user.id).where(shift: "キャッシュレス決済")
  end 

  private

  def set_common_params
    calc_valuation
    @shift_case = params[:shift_case]
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @results = Result.includes(:user, :result_cash).where(date: @start_date..@end_date)
    if @shift_case.present?
      if @shift_case == "d専売全て"
        @results = @results.where("product LIKE ?","d専売")
      else 
        @results = @results.where(product: @shift_case)
      end 
    end 
  end 

  def set_base_params
    @base = params[:base]
    @results_base = 
      @results.where(user: {base: @base}).where(shift: "キャッシュレス新規")
      @results_base_slmt = @results.where(user: {base: @base}).where(shift: "キャッシュレス決済")
    @users = 
      User.where.not(position: "退職").where(base_sub: "キャッシュレス").where(base: @base)
  end 
end
