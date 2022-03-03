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

  def new 
    @user = User.new 
  end 
  
  def create 
    @user = User.new(user_params)
    if @user.save 
      redirect_to user_path , alert: "#{@user.name}の登録が完了しました"
    else  
      render new 
    end 
  end 

  def edit 
    @user = User.find(params[:id])
  end 
  
  def update 
    p user_params
    @user = User.find(params[:id])
    @user.update(user_params)
      redirect_to users_path ,alert: "情報の更新をしました。"

  end 

  def show 
    @user = User.find(params[:id])
    @month = params[:month] ? Date.parse(params[:month]) : Time.zone.today

    @dmer_data = Dmer.includes(:store_prop).where(date: @month.all_month)
    @dmer_hubi = @dmer_data.where(user_id: @user.id).where(status: "不備対応中")
    @dmer_ng = @dmer_data.where(user_id: @user.id).where.not(status: "審査OK").where.not(status: "未審査").where.not(status: "審査待ち").where.not(status: "不備対応中")

    @aupay_data = Aupay.includes(:store_prop).where(date: @month.all_month)
    @aupay_hubi = @aupay_data.where(user_id: @user.id).where(status: "差し戻し")
    @aupay_ng = @aupay_data.where(user_id: @user.id).where.not(status: "審査通過").where.not(status: "未審査").where.not(status: "審査待ち").where.not(status: "差し戻し")

    @rakuten_pay_data = RakutenPay.includes(:store_prop).where(date: @month.all_month)
    @rakuten_pay_hubi = @rakuten_pay_data.where(user_id: @user.id).where(status: "自社不備")
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
      :email,
      :password,
      :password_confirmation
    )
  end

end
