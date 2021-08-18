class SummitsController < ApplicationController

  def index 
    @q = Summit.ransack(params[:q])
    @summits = 
      if params[:q].nil?
        Summit.none
      else
        @q.result(distinct: true)
      end

      @users = User.joins(:summit).where.not(summit: nil).distinct
      # 提出済み
      @amount_month = Summit.where(status: "提出済み").group("YEAR(get_date)").group("MONTH(get_date)").average(:amount_use)
      
      @low_voltage_month = Summit.where(status: "提出済み").where(contract_type: '低圧電力').group("YEAR(get_date)").group("MONTH(get_date)").average(:contract_cap) 
      @metered_month = Summit.where(status: "提出済み").where("contract_type = '従量電灯A' OR contract_type = '従量電灯B'").group("YEAR(get_date)").group("MONTH(get_date)").average(:contract_cap)
  
      @low_voltage_profit_expected = Summit.where(status: "提出済み").where(contract_type: '低圧電力').group("YEAR(start)").group("MONTH(start)").sum(:profit_expected)
      
      @metered_profit_expected = Summit.where(status: "提出済み").where("contract_type = '従量電灯A' OR contract_type = '従量電灯B'").group("YEAR(start)").group("MONTH(start)").sum(:profit_expected)
  
  
      @chart = [
        {name: "従量電灯", data: @metered_month},
        {name: "低圧電力", data: @low_voltage_month}
      ]
      @amount_chart = [{name: "使用量", data: @amount_month}]
  
  end 

  def new 
    @users = User.all
    @summit_customer_prop = SummitCustomerProp.find(params[:summit_customer_prop_id])
    @summit = Summit.new
  end 
  
  def create 
    @users = User.all
    @summit_customer_prop = SummitCustomerProp.find(params[:summit_customer_prop_id])
    @summit = Summit.new(summit_params)
    @summit.save 
    if @summit.save
      redirect_to summit_customer_prop_path(@summit.summit_customer_prop.id)
    else  
      render :new
    end 
  end 

  def import 
    Summit.import(params[:file])
    redirect_to summits_path
  end 

  def show 
    @summit = Summit.find(params[:id])
    @summit_customer_prop = SummitCustomerProp.find(params[:id])
    @summits = @summit_customer_prop.summits
    @store_prop = @summit_customer_prop.store_prop
  end 

  def edit 
    @summit = Summit.find(params[:id])
    @users = User.all
  end 
  
  def update 
    @summit = Summit.find(params[:id])
    @summit.update(summit_params)
    redirect_to summit_customer_prop_path(@summit.summit_customer_prop.id)
  end 

  def destroy 
    @summit = Summit.find(params[:id])
    @summit.destroy 
    redirect_to summits_path
  end 
  private 

  def summit_params 
    params.require(:summit).permit(
      :summit_customer_prop_id, 
      :user_id, 
      :get_date,
      :payment,
      :status, 
      :before_status,
      :supply_num, 
      :contract_num,
      :menu,
      :plan,
      :contract_type,
      :contract_cap,
      :contract_cap_unit,
      :amount_use, 
      :start,
      :profit,
      :profit_expected,
      :remarks, 
    )
  end 

end
