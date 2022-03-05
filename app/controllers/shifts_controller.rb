class ShiftsController < ApplicationController

  def index 
    @current_shifts = Shift.where(user_id: current_user.id)
    @shift = Shift.new
    @q = Shift.includes(:user).ransack(params[:q])
    @shifts = 
      if params[:q].nil?
        Shift.none 
      else 
        @q.result(distinct: false)
      end
    @results = Result.all
  end 
  
  
  def create 
    @shift = Shift.new(shift_params)
      if @shift.save
      flash[:notice] = "#{@shift.start_time.to_date}#{@shift.shift}のシフト申請をしました。"
      redirect_to shifts_path
    else 
      flash[:notice] = "申請に失敗しました。"
      redirect_to shifts_path
    end
  end 
  
  def show 
  end 

  def edit 
    @shift = Shift.find(params[:id])
  end 
  
  def update 
    @shift = Shift.find(params[:id])
    @shift.update(shift_params)
  end 

  def update_month
    month_shifts_params.keys.each do |key|
      @shifts_all = Shift.where(user_id: current_user.id).find_or_initialize_by(start_time: month_shifts_params[key][:start_time].to_date)
      @shifts_all.update(month_shifts_params[key])
    end
    flash[:notice] = "複数件の申請をしました"
    redirect_to shifts_path shifts_path 
  end 

  def destroy 
    @shift = Shift.find(params[:id])
    @shift.destroy 
    flash[:notice] = "#{@shift.start_time.to_date}#{@shift.shift}のシフトを削除をしました。"
    redirect_to 
  end 

  private 
  def shift_params 
    params.require(:shift).permit(:user_id,:start_time,:shift)
  end 
  def month_shifts_params 
    params.require(:shift).permit!
  end 
end
