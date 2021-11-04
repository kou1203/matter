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
    @form = Form::ShiftCollection.new
  end 

  def create 
    @form = Form::ShiftCollection.new(shift_collection_params)
    if @form.save 
      redirect_to shifts_path notice: "登録しました"
    else  
      flash.now[:alert] = "失敗しました"
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
  def shift_collection_params 
    params.require(:form_shift_collection).permit(shifts_attributes: [:user_id,:date,:shift,:availability])
  end 
  
end
