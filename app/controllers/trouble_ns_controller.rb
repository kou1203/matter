
class TroubleNsController < ApplicationController

  def index 
    @q = TroubleN.ransack(params[:q])
    @trouble_ns = 
      if params[:q].nil?
        TroubleN.none
      else
        @q.result(distinct: false)
      end
      @trouble_ns_month = TroubleN.where(date: Time.now.beginning_of_month..Time.now.end_of_month)
      @month_ago = TroubleN.where(date: Time.now.months_ago(1).beginning_of_month..Time.now.months_ago(1).end_of_month)
      @week_ago = TroubleN.where(date: Time.now.weeks_ago(1)..Time.now)
      @users = User.all
  end 

  def new 
    @users = User.all
    @trouble_n = TroubleN.new
  end 
  
  def create 
    @users = User.all
    @trouble_n = TroubleN.new(trouble_n_params)
    if @trouble_n.save 
      redirect_to trouble_ns_path 
    else  
      render :new 
    end 
  end 

  def show 
    @trouble_ns_month = TroubleN.where(date: Time.now.beginning_of_month..Time.now.end_of_month)
    @month_ago = TroubleN.where(date: Time.now.months_ago(1).beginning_of_month..Time.now.months_ago(1).end_of_month)
    @week_ago = TroubleN.where(date: Time.now.weeks_ago(1)..Time.now)
    @users = User.all
  end 

  def edit 
    @users = User.all
    @trouble_n = TroubleN.find(params[:id])
  end 
  
  def update 
    @users = User.all
    @trouble_n = TroubleN.find(params[:id])
    @trouble_n.update(trouble_n_params)
    redirect_to trouble_ns_path
  end 

  def import 
    TroubleN.import(params[:file])
    redirect_to trouble_ns_path
  end 

  private 
  def trouble_n_params 
    params.require(:trouble_n).permit(
      :base                  ,
      :date                    ,
      :category              ,
      :customer_name         ,
      :get_status            ,
      :contract_type         ,
      :user_id              ,
      :confirmer             ,
      :content_type          ,
      :customer_caller       ,
      :customer_opinion        ,
      :user_opinion            ,
      :result                  ,
    )
  end 
end
