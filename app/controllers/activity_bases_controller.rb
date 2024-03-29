class ActivityBasesController < ApplicationController
  include Base
  before_action :set_month
  def index 
    bases
    @activity_bases = ActivityBase.where(date: @month.beginning_of_month)
  end 

  def bulk_create
    cnt = 0
    user_groups = Shift.group(:user_id)
    user_groups.each do |user_group|
      activity_base = ActivityBase.where(date: @month.beginning_of_month)
      activity_base = activity_base.find_by(user_id: user_group.user_id)
      
      if user_group.user.position == "退職"
        user_base = user_group.user.position
      elsif user_group.user.base_sub == "キャッシュレス"
        user_base = user_group.user.base
      else  
        user_base = "その他"
      end 

      activity_base_params = {
        user_id: user_group.user_id                   ,
        date: @month.beginning_of_month               ,
        position: user_group.user.position_sub        ,
        base: user_base
      }
      if activity_base.present?
        activity_base.update(
          activity_base_params
        )
      else  
        activity_base = ActivityBase.new(
          activity_base_params
        )
        activity_base.save
      end
      cnt += 1    
    end 
    redirect_to activity_bases_path,alert: "#{cnt}件のユーザー拠点、役職情報を保存しました。"
  end  

  def edit 
    @activity_base = ActivityBase.find(params[:id])
  end 

  def update 
    @activity_base = ActivityBase.find(params[:id])
    @activity_base.update(activity_base_strong_params)
    redirect_to activity_bases_path, alert: "#{@activity_base.user.name}さんの情報を編集しました。"
  end

  def destroy 
    @activity_base = ActivityBase.find(params[:id])
    @activity_base.destroy
    redirect_to activity_bases_path, alert: "#{@activity_base.user.name}さんの情報を削除しました。"
  end 

  private 
  def set_month
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
  end 

  def activity_base_strong_params 
    params.require(:activity_base).permit(
      :user_id,
      :date,
      :position,
      :base
    )
  end 
end
