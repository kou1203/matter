class ShiftsController < ApplicationController

  def index 
    @user = current_user
    @users_cash = User.where(base_sub: "キャッシュレス")
    @current_shifts = Shift.where(user_id: @user.id)
    @shift = Shift.new
    @q = Shift.includes(:user).ransack(params[:q])
    @shifts = 
      if params[:q].nil?
        Shift.none 
      else 
        @q.result(distinct: false)
      end
    @results = Result.all
    @result_list = @results.where(date:@shifts.minimum(:start_time)..@shifts.maximum(:start_time))
    @result_list = 
      @result_list.where(shift: "キャッシュレス新規")
      .or(
        @result_list.where(shift: "キャッシュレス決済")

      )
    session[:previous_url] = request.referer
  end 

  def new 
    @shift = Shift.new({user_id: params[:user_id],start_time: params[:date]})
    session[:previous_url] = request.referer
  end 
  
  
  def create 
    @shift = Shift.new(shift_params)
      if @shift.save
      flash[:notice] = "#{@shift.start_time.to_date}#{@shift.shift}のシフト申請をしました。"
      redirect_to session[:previous_url]
    else 
      flash[:notice] = "申請に失敗しました。"
      redirect_to session[:previous_url]
    end
  end 
  
  def show 
    @user = User.find(params[:id])
    @results = Result.where(user_id: params[:id])
    @current_shifts = Shift.where(user_id: params[:id])
    @shift = Shift.new
  end 

  def edit 
    @shift = Shift.find(params[:id])
    session[:previous_url] = request.referer
  end 
  
  def update 
    @shift = Shift.find(params[:id])
    @shift.update(shift_params)
    redirect_to session[:previous_url]
  end 

  def update_month
    month_shifts_params.keys.each do |key|
      if month_shifts_params[key][:user_id].present?
        @u_id = month_shifts_params[key][:user_id]
        @shifts_all = Shift.where(user_id: @u_id).find_or_initialize_by(start_time: month_shifts_params[key][:start_time].to_date)
        @shifts_all.update(month_shifts_params[key])
      end
    end
    flash[:notice] = "複数件の申請をしました"
    if @u_id.present? && (@u_id != current_user.id)
      redirect_to shift_path(@u_id)  
    else
      redirect_to shifts_path shifts_path 
    end 
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
