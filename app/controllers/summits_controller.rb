class SummitsController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @q = Summit.includes(:user, :store_prop,:summit_client,:summit_price).ransack(params[:q])
    @summits = 
      if params[:q].nil?
        Summit.none 
      else 
        @q.result(distinct: false)
      end
      @summits_data = @summits.page(params[:page]).per(100)
    @users = User.where(base_sub: "サミット")

    @summit_month = Summit.includes(:user, :store_prop,:summit_client,:summit_price).where(date: @month.beginning_of_month..@month.end_of_month)
    @summit_month_data = @summit_month.page(params[:page]).per(100)
  end


  def new 
    @summit = Summit.new
  end 
  
  def create 
    @summit = Summit.new(summit_params)
    @summit.save 
    if @summit.save
      redirect_to summit_customer_prop_path(@summit.summit_customer_prop.id)
    else  
      render :new
    end 
  end 

  def import 
    if params[:file].present?
      if Summit.csv_check(params[:file]).present?
        redirect_to summits_path , alert: "エラーが発生したため中断しました#{Summit.csv_check(params[:file])}"
      else
        message = Summit.import(params[:file]) 
        redirect_to summits_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to summits_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 
  def import_price 
    if params[:file].present?
      if SummitPrice.csv_check(params[:file]).present?
        redirect_to summits_path , alert: "エラーが発生したため中断しました#{SummitPrice.csv_check(params[:file])}"
      else
        message = SummitPrice.import(params[:file]) 
        redirect_to summits_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to summits_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def sw_error
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @users = User.where(base_sub: "サミット")
    @sw_errors = Summit.includes(:summit_client).where(status: "SWエラー").where(date: @month.beginning_of_month..@month.end_of_month)
  end 

  def show 
    @summit = Summit.includes(:summit_client,:summit_billing_amounts).find(params[:id])
  end 

  def edit 
    @summit = Summit.find(params[:id])
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

  def cancel
    @users = User.where(base_sub: "サミット")
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @year_parse = @month.to_date.all_year
    @areas = ["中部","関西","東京","中国"]
    @summits_monthly = 
      Summit.includes(:store_prop, :user,:summit_client,:summit_billing_amounts)
      .where(summit_client: {cancel: @month.beginning_of_month..@month.end_of_month})
    # グラフ

    @summit_clients = SummitClient.where(cancel: @year_parse)
    @summits_line_graph = [
      {
        name: "全体廃止件数", data: @summit_clients.group("MONTH(cancel)").count
      },
      {
        name: "中部廃止件数", data: @summit_clients.where(area: "中部").group("MONTH(cancel)").count
      },
      {
        name: "関西廃止件数", data: @summit_clients.where(area: "関西").group("MONTH(cancel)").count
      },
      {
        name: "東京廃止件数", data: @summit_clients.where(area: "東京").group("MONTH(cancel)").count
      },
      {
        name: "中国廃止件数", data: @summit_clients.where(area: "中国").group("MONTH(cancel)").count
      },
    ]
    @campany_pie_graph = SummitClient.where(cancel: @year_parse).group(:cancel_app_company).count
    @billings = SummitBillingAmount.where(payment_date: @month.beginning_of_month..@month.end_of_month)
    @billings_prev = SummitBillingAmount.where(payment_date: @month.prev_month.beginning_of_month..@month.prev_month.end_of_month)
  end 
  private 

  def summit_params 
  end 

end
