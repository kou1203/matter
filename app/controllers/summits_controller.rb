class SummitsController < ApplicationController

  def index 
    @q = Summit.includes(:user, :store_prop,:summit_client,:summit_price).ransack(params[:q])
    @summits = 
      if params[:q].nil?
        Summit.none 
      else 
        @q.result(distinct: false)
      end
      @summits_data = @summits.page(params[:page]).per(100)
  end


  def new 
    @summit = Summit.new
  end 
  
  def create 
    @users = User.all
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
    @sw_errors = Summit.includes(:summit_client).where(status: "SWエラー")
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
  private 

  def summit_params 
  end 

end
