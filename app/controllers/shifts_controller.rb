class ShiftsController < ApplicationController

  def index 
    @q = Shift.ransack(params[:q])
    @shifts = 
      if params[:q].nil?
        Shift.none
      else  
        @q.result(distinct: true)
      end
  end 

  def new 
    @shift = Shift.new
  end 

  def create 
    @shift = Shift.new(shift_params)
    @shift.save 
    if @shift.save 
      redirect_to shifts_path 
    else  
      render :new 
    end 
  end 

  def show 
    @shift = Shift.find(params[:id])
  end 

  def edit 
    @shift = Shift.find(params[:id])
  end 
  
  def update 
    @shift = Shift.find(params[:id])
    @shift.update(shift_params)
    redirect_to shifts_path
  end 

  def destroy 
    @shift = Shift.find(params[:id])
    @shift.destroy 
    redirect_to shifts_path
  end 

  private 
  def shift_params 
    params.require(:shift).permit(
      :user_id,
      :year,
      :month,
      :house_work,
      :ojt,
      :n,
      :rakuten_casa,
      :cashless_new,
      :cashless_settlement,
      :praness,
      :summit,
      :panda,
      :goal
    )
  end 
  
end
