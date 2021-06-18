class SummitCustomerPropsController < ApplicationController

  def index 
    @summits = Summit.all
    @users = User.joins(:summit).where.not(summit: nil).distinct
    # 提出済み
    @amount_month = Summit.where(status: "提出済み").group("YEAR(get_date)").group("MONTH(get_date)").average(:amount_use)
    
    @low_voltage_month = Summit.where(status: "提出済み").where(contract_type: '低圧電力').group("YEAR(get_date)").group("MONTH(get_date)").average(:contract_cap) 
    @metered_month = Summit.where(status: "提出済み").where("contract_type = '従量電灯A' OR contract_type = '従量電灯B'").group("YEAR(get_date)").group("MONTH(get_date)").average(:contract_cap)

    @low_voltage_claim_expected = Summit.where(status: "提出済み").where(contract_type: '低圧電力').group("YEAR(start)").group("MONTH(start)").sum(:claim_expected)
    
    @metered_claim_expected = Summit.where(status: "提出済み").where("contract_type = '従量電灯A' OR contract_type = '従量電灯B'").group("YEAR(start)").group("MONTH(start)").sum(:claim_expected)


    @chart = [
      {name: "従量電灯", data: @metered_month},
      {name: "低圧電力", data: @low_voltage_month}
    ]
    @amount_chart = [{name: "使用量", data: @amount_month}]

  end 

  def new 
    @store_prop = StoreProp.find(params[:store_prop_id])
    @summit_customer_prop = SummitCustomerProp.new 
    
  end 
  
  def create 
    @store_prop = StoreProp.find(params[:store_prop_id])
    @summit_customer_prop = SummitCustomerProp.new(summit_customer_prop_params)
    if @summit_customer_prop.save 
      redirect_to store_prop_path(@store_prop.id)
    else  
      render :new 
    end
  end 

  def import 
    SummitCustomerProp.import(params[:file])
    redirect_to summit_customer_props_path
  end 

  def show 
    @summit_customer_prop = SummitCustomerProp.find(params[:id])
    @store_prop = @summit_customer_prop.store_prop
    @summits = @summit_customer_prop.summits

  end 

  def edit 
    @summit_customer_prop = SummitCustomerProp.find(params[:id])
    @store_prop = @summit_customer_prop.store_prop
    
    
  end 
  
  def update 
    @summit_customer_prop = SummitCustomerProp.find(params[:id])
    @store_prop = @summit_customer_prop.store_prop
    @summit_customer_prop.update(summit_customer_prop_params)
    if @summit_customer_prop.update(summit_customer_prop_params)
      redirect_to store_prop_path(@store_prop.id)
    else  
      render :edit 
    end 
  end 
  private 
  def summit_customer_prop_params 
    params.require(:summit_customer_prop).permit(
      :customer_num,
      :client,
      :store_prop_id,
      :claim_house,
      :claim_address,
      :contract_name,
      :before_electric
    )
  end 
end
