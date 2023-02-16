class SummitBillingAmountsController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @billing_date = @month.ago(3.month).strftime("%Y年%m月")
    @summit_month_data = SummitBillingAmount.where(billing_date: @billing_date).page(params[:page]).per(100)
    @q = SummitBillingAmount.includes(:user).ransack(params[:q])
    @summits = 
      if params[:q].nil?
        SummitBillingAmount.none 
      else 
        @q.result(distinct: false)
      end
      @summits_data = @summits.page(params[:page]).per(100)
      @users = User.where(base_sub: "サミット")
  end 

  def import
    if params[:file].present?
      if SummitBillingAmount.csv_check(params[:file]).present?
        redirect_to summit_billing_amounts_path , alert: "エラーが発生したため中断しました#{SummitBillingAmount.csv_check(params[:file])}"
      else
        message = SummitBillingAmount.import(params[:file]) 
        redirect_to summit_billing_amounts_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to summit_billing_amounts_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  private
end
