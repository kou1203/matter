class DmersController < ApplicationController
  before_action :authenticate_user!
  require 'csv'
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @q = Dmer.includes(:store_prop, :user).ransack(params[:q])
    @dmers = 
      if params[:q].nil?
        Dmer.none 
      else
        @q.result(distinct: false)
      end
    @dmers_data = @dmers.page(params[:page]).per(100)
  end 

  def new
    @dmer = Dmer.new
    @users = User.where.not(position: "退職")
    @store_prop = StoreProp.find(params[:store_id])
  end 
  
  def create 
    @dmer = Dmer.new(dmer_params)
    @store_prop = StoreProp.find(@dmer.store_prop_id)
    @users = User.where.not(position: "退職")
    @dmer.save 
    if @dmer.save 
      redirect_to store_prop_path(@dmer.store_prop_id) 
    else  
      render :new 
    end 
  end 

  def simple_conf
    # 月間進捗
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @bases = ["中部SS", "関西SS", "関東SS", "九州SS", "2次店"]
    @monthly_data = Dmer.includes(:user).where(date: @month.all_month)
    @monthly_done = 
      Dmer.includes(:user).where(result_point: @month.all_month).where(status: "審査OK").where.not(industry_status: "NG").where.not(industry_status: "×").where.not(industry_status: "要確認")
    @monthly_slmt = 
      Dmer.includes(:user).where(settlement: @month.all_month).where(status: "審査OK").where.not(industry_status: "NG").where.not(industry_status: "×").where.not(industry_status: "要確認")
    @monthly_2nd_slmt = Dmer.includes(:user).where(settlement_second: @month.all_month).where(status: "審査OK").where.not(industry_status: "NG").where.not(industry_status: "×").where.not(industry_status: "要確認")
    @monthly_pic = Dmer.includes(:user).where(picture: @month.all_month).where(status: "審査OK").where.not(industry_status: "NG").where.not(industry_status: "×").where.not(industry_status: "要確認")
    @monthly_pic_done = Dmer.includes(:user).where(status_update_settlement: @month.all_month).where(status: "審査OK").where.not(industry_status: "NG").where.not(industry_status: "×").where.not(industry_status: "要確認").where(status_settlement: "完了")
    @monthly_slmt_dead = Dmer.includes(:user).where(settlement_deadline: @month.all_month)
    .where(status: "審査OK").where.not(industry_status: "NG").where.not(industry_status: "×").where.not(industry_status: "要確認").where(status_settlement: "期限切れ")
    @dmers_def = @monthly_data.where.not(def_status: nil)
    @shifts = Shift.includes(:user).where(shift: "キャッシュレス新規").where(start_time: @month.all_month)
    @results = Result.includes(:user).where(shift: "キャッシュレス新規").where(date: @month.all_month)  
  end 

  def simple_conf_year 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @bases = ["中部SS", "関西SS", "関東SS", "九州SS", "2次店"]
    @dmers = Dmer.where(date: @month.all_year)
  end 

  def show 
    @dmer = Dmer.find(params[:id])
    @users = User.all
  end 

  def edit 
    @dmer = Dmer.find(params[:id])
    @users = User.all
  end 
  
  def update 
    @dmer = Dmer.find(params[:id])
    @dmer.update(dmer_params)
    redirect_to dmer_path(@dmer.id)
  end 

  def import 
    if params[:file].present?
      if Dmer.csv_check(params[:file]).present?
        redirect_to dmers_path , alert: "エラーが発生したため中断しました#{Dmer.csv_check(params[:file])}"
      else
        message = Dmer.import(params[:file]) 
        redirect_to dmers_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to dmers_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def deficiency
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @bases = ["中部SS","関西SS","関東SS","2次店"]
    @dmers_def = Dmer.includes(:user).where.not(deficiency: nil).where(deficiency: @month.in_time_zone.all_year)
    @def_graph = []
      @bases.each do |base|
        def_base = {
          name: "#{base}不備件数", data: @dmers_def.where(user: {base: base}).where(deficiency: @month.in_time_zone.all_year).group("MONTH(deficiency)").count
        }
        @def_graph << def_base
      end
  end 

  def index_export
    @dmers = Dmer.includes(:user).all
    filename = "dメル一覧"
    columns_ja = [
      "商流","管理番号", "申込番号","店舗名", "獲得者",
      "獲得日", "業種チェック","審査ステータス","審査完了日","決済対応者",
      "初回決済日","アクセプタンス","アクセプタンス合格日",
      "2回目決済"
    ]
    columns = [
      "client","controll_num", "customer_num","store_prop_name","user_name",
      "date","industry_status","status","result_point", "settlementer",
      "settlement","picture","status_update_settlement",
      "settlement_second"
    ]
    bom = "\uFEFF"
    csv = CSV.generate(bom) do |csv|
      csv << columns_ja
      @dmers.find_each do |dmer|
        result_attributes = {}
        result_attributes["client"] = dmer.client
        result_attributes["controll_num"] = dmer.controll_num
        result_attributes["customer_num"] = dmer.customer_num
        result_attributes["store_prop_name"] = dmer.store_prop.name
        result_attributes["user_name"] = dmer.user.name
        result_attributes["date"] = dmer.date
        result_attributes["industry_status"] = dmer.industry_status
        result_attributes["status"] = dmer.status
        result_attributes["result_point"] = dmer.result_point
        if dmer.settlementer.present?
        result_attributes["settlementer"] = dmer.settlementer.name
        else
        result_attributes["settlementer"] = ""
        end
        result_attributes["settlement"] = dmer.settlement
        result_attributes["picture"] = dmer.picture
        result_attributes["status_update_settlement"] = dmer.status_update_settlement
        result_attributes["settlement_second"] = dmer.settlement_second
        csv << result_attributes.values_at(*columns)
      end 
    end 
    create_csv(filename,csv)
  end 

  def self.export
    filename = "dメル一覧"
    columns_ja = [
      "管理番号", "店舗名", "獲得者","獲得日", "初回決済日",
    ]
    columns = [
      "controll_num", "store_prop_name", "user_name", "date","settlement"
    ]
    bom = "\uFEFF"
    csv = CSV.generate(bom) do |csv|
      csv << columns_ja
      @dmers.each do |dmer|
        result_attributes = {}
        result_attributes["controll_num"] = dmer.controll_num
        result_attributes["store_prop_name"] = dmer.store_prop.name
        result_attributes["user_name"] = dmer.user.name
        result_attributes["date"] = dmer.date
        result_attributes["settlement"] = dmer.settlement
        csv << result_attributes.values_at(*columns)
      end 
    end 
    create_csv(filename,csv)
  end 


  private 



  def create_csv(filename, csv1)
    #ファイル書き込み
    File.open("./#{filename}.csv", "w") do |file|
      file.write(csv1)
    end
    #send_fileを使ってCSVファイル作成後に自動でダウンロードされるようにする
    stat = File::stat("./#{filename}.csv")
    send_file("./#{filename}.csv", filename: "#{filename}.csv", length: stat.size)
  end

  def dmer_params
    params.require(:dmer).permit(
      :customer_num,
      :controll_num,
      :client,
      :user_id,
      :store_prop_id,
      :date,
      :share,
      :industry_status,
      :app_check,
      :app_check_date,
      :status,
      :status_update,
      :shipment,
      :settlementer_id,
      :settlement,
      :settlement_second,
      :picture,
      :picture_update,
      :settlement_deadline,
      :status_settlement,
      :status_update_settlement,
      :payment,
      :payment_settlement,
      :result_point,
      :result_point_settlement,
      :deficiency,   
      :deficiency_settlement,   
      :deficiency_solution,
      :deficiency_solution_settlement,
      :deficiency_deadline,
      :deficiency_remarks, 
      :deficiency_remarks_settlement, 
      :description,
      :profit_new,
      :profit_settlement,
      :profit_second_settlement,
      :valuation_new,    
      :valuation_settlement,
      :valuation_second_settlement
    )
  end 

end
