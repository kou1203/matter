class RakutenPaysController < ApplicationController

  def index 
    @q = RakutenPay.includes(:store_prop).ransack(params[:q])
    @rakuten_pays = 
    if params[:q].nil?
      RakutenPay.none 
    else  
      @q.result(distinct: true)
    end
    @rakuten_pays_data = @rakuten_pays.page(params[:page]).per(100)
  end 

  def new
    @rakuten_pay = RakutenPay.new 
    @users = User.all 
    @store_prop = StoreProp.find(params[:store_prop_id]) 
  end  
  
  def create 
    @rakuten_pay = RakutenPay.new(rakuten_pay_params)
    @users = User.all 
    @store_prop = StoreProp.find(params[:store_prop_id])
    if @rakuten_pay.save 
      redirect_to rakuten_pay_path(@rakuten_pay.id) 
    else  
      render :new 
    end 
  end 
  
  def edit 
    @rakuten_pay = RakutenPay.find(params[:id])
    @users = User.all 
  end 
  
  def update 
    @rakuten_pay = RakutenPay.find(params[:id])
    @rakuten_pay.update(rakuten_pay_params)
    redirect_to rakuten_pay_path(@rakuten_pay.id) 
  end 

  def show 
    @rakuten_pay = RakutenPay.find(params[:id])
  end 

  def import 
    if params[:file].present?
      if RakutenPay.csv_check(params[:file]).present?
        redirect_to rakuten_pays_path , alert: "エラーが発生したため中断しました#{RakutenPay.csv_check(params[:file])}"
      else
        message = RakutenPay.import(params[:file]) 
        redirect_to rakuten_pays_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to rakuten_pays_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def deficiency
    @bases = ["中部SS","関西SS","関東SS","2次店"]
    @rakuten_pays_def = RakutenPay.includes(:user).where.not(client_def_date: nil)
    @def_graph = []
    
      @bases.each do |base|
        def_base = {
          name: "#{base}不備件数", data: @rakuten_pays_def.where(user: {base: base}).group("YEAR(client_def_date)").group("MONTH(client_def_date)").count
        }
        @def_graph << def_base
      end
    
  end 

  def simple_conf
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @bases = ["中部SS", "関西SS", "関東SS", "九州SS", "2次店"]
    @results = Result.includes(:user).where(shift: "キャッシュレス新規").where(date: @month.beginning_of_month..@month.end_of_month)
    @monthly_data = RakutenPay.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
    @monthly_share = RakutenPay.includes(:user).where(share: @month.beginning_of_month..@month.end_of_month)
    @monthly_done = 
    RakutenPay.includes(:user).where(result_point: @month.beginning_of_month..@month.end_of_month).where(status: "審査OK")
      .or(
        RakutenPay.includes(:user).where(result_point: @month.beginning_of_month..@month.end_of_month).where(status: "OK")
      )
    @monthly_def = RakutenPay.includes(:user).where(deficiency: @month.beginning_of_month..@month.end_of_month)
    @monthly_def_solution = RakutenPay.includes(:user).where(deficiency_solution: @month.beginning_of_month..@month.end_of_month)
    @monthly_client_def = RakutenPay.includes(:user).where(client_def_date: @month.beginning_of_month..@month.end_of_month)
    @monthly_client_def_solution = RakutenPay.includes(:user).where(client_def_solution: @month.beginning_of_month..@month.end_of_month)
  end

  private 
  def rakuten_pay_params 
    params.require(:rakuten_pay).permit(
      :client,
      :user_id,
      :store_prop_id,
      :date,
      :share,
      :status,
      :transcript,
      :customer_num,
      :status_update,
      :deficiency,
      :deficiency_solution,
      :payment,
      :deficiency_info,
      :deficiency_consent,
      :result_point,
      :profit,
      :valuation
    )
  end
end
