class SummitCustomerPropsController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @summit_customer_prop_index = SummitCustomerProp.where(create_datetime: @month.ago(2.month)..@month.end_of_month).page(params[:page]).per(50)
    @q = SummitCustomerProp.includes(:user).ransack(params[:q])
    @summit_customer_props = 
      if params[:q].nil?
        SummitCustomerProp.none 
      else 
        @q.result(distinct: false)
      end
      @summit_customer_props_data = @summit_customer_props.page(params[:page]).per(100)
      @users = User.where(base_sub: "サミット")
  end 

  def show 
    @summit_customer_prop = SummitCustomerProp.find(params[:id])
    @summit_customer_props = SummitCustomerProp.where(history_record_num: @summit_customer_prop.history_record_num)
  end 

  def import 
    if params[:file].present?
      if SummitCustomerProp.csv_check(params[:file]).present?
        redirect_to summit_customer_props_path, alert: "エラーが発生したため中断しました#{SummitCustomerProp.csv_check(params[:file])}"
      else
        message = SummitCustomerProp.import(params[:file]) 
        redirect_to summit_customer_props_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to summit_customer_props_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 
  private 

end
