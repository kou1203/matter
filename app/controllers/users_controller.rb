class UsersController < ApplicationController

  def index 
    @q = User.ransack(params[:q])
    @users = 
      if params[:q].nil? 
        User.none 
      else    
        @q.result(distinct: false)
      end
  end 

  def edit 
    @user = User.find(params[:id])
  end 
  
  def update 
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to users_path
  end 

  def show 
    @user = User.find(params[:id])

  end 


  private 
  def user_params 
    params.require(:user).permit(
      :base,
      :base_sub,
      :position,
      :position_sub,
      :group,
      :team,
    )
  end
end