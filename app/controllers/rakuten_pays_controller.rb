class RakutenPaysController < ApplicationController
  before_action :set_def_category, only: [:simple_conf,:deficiency,:deficiency_new]
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
    @store_prop = StoreProp.find(params[:store_id])
  end  
  
  def create 
    @rakuten_pay = RakutenPay.new(rakuten_pay_params)
    @users = User.all 
    @store_prop = @rakuten_pay.store_prop_id
    if @rakuten_pay.save 
      redirect_to store_prop_path(@store_prop) 
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
    @bases = ["中部SS","関西SS","関東SS","九州SS","2次店"]
    @rakuten_pays = RakutenPay.where(share: ..Date.new(2022,12,31))
    @def_monthly = @rakuten_pays.where.not(def_status: nil).or(@rakuten_pays.where.not(def_status2: nil)).order(:date).group("YEAR(date)").group("MONTH(date)").count
    @def_cancel_monthly = @rakuten_pays.where(status: "申込取消（不備）").or(@rakuten_pays.where(status: "申込取消")).group("YEAR(date)").group("MONTH(date)").count
    @rakuten_pays_def = @rakuten_pays.includes(:user).where.not(client_def_date: nil)
    @rakuten_pays_def1 = @rakuten_pays.includes(:user).where.not(def_status: nil)
    @rakuten_pays_def2 = @rakuten_pays.includes(:user).where.not(def_status2: nil)
    @def_graph = []
      @bases.each do |base|
        def_base = {
          name: "#{base}不備件数", data: @rakuten_pays_def.where(user: {base: base}).group("YEAR(client_def_date)").group("MONTH(client_def_date)").count
        }
        @def_graph << def_base
      end
  end 

  def deficiency_new
    @bases = ["中部SS","関西SS","関東SS","九州SS","2次店"]
    @rakuten_pays = RakutenPay.where(share: Date.new(2023,1,1)..)
    @def_monthly = @rakuten_pays.where.not(def_status: nil).or(@rakuten_pays.where.not(def_status2: nil)).order(:share).group("YEAR(share)").group("MONTH(share)").count
    @def_cancel_monthly = @rakuten_pays.where.not(def_status: nil).where(status: "申込取消（不備）").or(@rakuten_pays.where.not(def_status: nil).where(status: "申込取消")).group("YEAR(share)").group("MONTH(share)").count
    @rakuten_pays_def = @rakuten_pays.includes(:user).where.not(client_def_date: nil)
    @rakuten_pays_def1 = @rakuten_pays.includes(:user).where.not(def_status: nil)
    @rakuten_pays_def2 = @rakuten_pays.includes(:user).where.not(def_status2: nil)
    @def_graph = []
    @def_graph << {
      name: "全拠点不備件数", data: @rakuten_pays_def.group("YEAR(client_def_date)").group("MONTH(client_def_date)").count
    }
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
    @monthly_def_solution = RakutenPay.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month).where.not(deficiency_solution: nil)
    @monthly_client_def = @monthly_data.where.not(def_status: nil)
    @monthly_client_def_solution = @monthly_client_def.where(status: "OK")
    @monthly_client_def_cancel = @monthly_client_def.where(status: "申込取消（不備）")
  end

  def index_export
    @rakuten_pays = RakutenPay.includes(:user).all
    filename = "楽天ペイ一覧"
    columns_ja = [
      "申込番号","店舗名", "獲得者",
      "獲得日","審査ステータス","審査完了日","入金フラグ"
    ]
    columns = [
      "customer_num","store_prop_name","user_name",
      "date","status","result_point","payment_flag"
    ]
    bom = "\uFEFF"
    csv = CSV.generate(bom) do |csv|
      csv << columns_ja
      @rakuten_pays.find_each do |rakuten_pay|
        result_attributes = {}
        result_attributes["customer_num"] = rakuten_pay.customer_num
        result_attributes["store_prop_name"] = rakuten_pay.store_prop.name
        result_attributes["user_name"] = rakuten_pay.user.name
        result_attributes["date"] = rakuten_pay.date
        result_attributes["status"] = rakuten_pay.status
        result_attributes["result_point"] = rakuten_pay.result_point
        result_attributes["payment_flag"] = rakuten_pay.payment_flag
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

  def set_def_category
    @def_category = {
      "101": "WEB≠申込商材","102": "販売形態","103": "車関連商材", "104": "既存店と情報一致","105": "他経路申込と情報一致","106": "既存店と情報相違",
      "107": "（解約新規懸念）", "201": "資料不鮮明", "202": "資料有効期限切れ","203": "資料内容不足", "204": "必要資料不足","301": "WEB無し判断",
      "302": "WEB差し替え依頼", "3031": "一部実態取得不可","304": "口座格齟齬", "305": "口座情報齟齬（個人）", "306": "口座情報齟齬（法人）",
      "401": "WEB≠申込情報", "402": "書類≠申込情報", "403": "フリガナ齟齬","404": "郵政不一致","405": "法人懸念", "406": "屋号１５文字以上",
      "9901": "その他","802": "商材相違","804": "二重申込","805": "二重申込疑義","806": "二重申込（解約依頼）"
    } 
  end 

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
      :valuation,
      :payment_flag,
      :payment_deadline
    )
  end
end
