class DmerSenbaiUsersController < ApplicationController
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @users = User.includes(:dmer_senbai_users).where(base_sub: "キャッシュレス").where.not(position: "退職")
    @bases = ["中部SS", "関西SS","関東SS","九州SS","２次店"]
  end 

  def new 
    @select_columns = SelectColumn.where(category: "d専売商流")
    @user = User.find(params[:user_id])
    @dmer_senbai_user = DmerSenbaiUser.new()
  end 

  def create 
    @dmer_senbai_user = DmerSenbaiUser.new(dmer_senbai_user_params)
    if @dmer_senbai_user.save
      redirect_to dmer_senbai_users_path, alert: "#{@dmer_senbai_user.user.name}のdメル専売期間を#{@dmer_senbai_user.date.strftime('%Y年%m月')}で保存しました。"
    else 
      redirect_to new_dmer_senbai_user_path(user_id: @dmer_senbai_user.user_id), alert: "入力する項目を全て埋めてください。"
    end 
  end 

  def edit 
    @select_columns = SelectColumn.where(category: "d専売商流")
    @dmer_senbai_user = DmerSenbaiUser.find(params[:id])
  end 
  
  def update 
    @dmer_senbai_user = DmerSenbaiUser.find(params[:id])
    @dmer_senbai_user.update(dmer_senbai_user_params)
    redirect_to dmer_senbai_users_path, alert: "#{@dmer_senbai_user.user.name}のdメル専売情報を更新しました。"
  end 

  def destroy
    @dmer_senbai_user = DmerSenbaiUser.find(params[:id])
    @dmer_senbai_user.destroy 
    redirect_to dmer_senbai_users_path, alert: "#{@dmer_senbai_user.user.name}#{@dmer_senbai_user.date.strftime('%Y年%m月')}のdメル専売情報を削除しました。"
  end 
  
  private 
  def dmer_senbai_user_params 
    params.require(:dmer_senbai_user).permit(:user_id,:client,:date)
  end 
end
