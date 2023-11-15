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
        user_base = user_group.user.base_sub
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
  end 

  def update 
  end

  private 
  def set_month
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
  end 
end
