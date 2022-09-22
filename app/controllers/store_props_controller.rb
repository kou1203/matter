require "csv"
class StorePropsController < ApplicationController
  before_action :authenticate_user!
  before_action :back_retirement, only: [:index]
  def index 
    @q = StoreProp.includes(:dmer, :aupay, :paypay,:rakuten_pay,:demaekan).ransack(params[:q])
    @store_props = 
      if params[:q].nil?
        StoreProp.none 
      else
        @q.result(distinct: true)
      end
      @store_props_data = @store_props.page(params[:page]).per(100)

      @store_props_csv = StoreProp.includes(:dmer, :aupay, :paypay, :rakuten_pay)
      respond_to do |format|
        format.html
        format.csv do |csv|
          send_pranesses_csv(@store_props_csv)
        end 
      end

  end 

  def new 
    @store_prop = StoreProp.new
  end 

  def create 
    @store_prop = StoreProp.new(store_prop_params)
    if @store_prop.save
      redirect_to store_prop_path(@store_prop.id)
    else 
      render :new
    end

  end 

  def edit 
    @store_prop = StoreProp.find(params[:id])
  end 
  
  def update 
    @store_prop = StoreProp.find(params[:id])
    @store_prop.update(store_prop_params)
    redirect_to store_prop_path(@store_prop.id)
  end 

  def import 
    if params[:file].present?
      if StoreProp.csv_check(params[:file]).present?
        redirect_to store_props_path , alert: "エラーが発生したため中断しました#{StoreProp.csv_check(params[:file])}"
      else
        message = StoreProp.import(params[:file]) 
        redirect_to store_props_path, alert: "インポート処理を完了しました#{message}"
      end
    else
      redirect_to store_props_path, alert: "インポートに失敗しました。ファイルを選択してください"
    end
  end 

  def export 
    @store_props_csv = StoreProp.includes(:dmer, :aupay, :paypay, :rakuten_pay)
    head :no_content
    filename = "店舗情報一覧#{Date.today}"
    
    columns_ja = [
      "店舗名", "本店名", "法人/個人", "業種",
      "都道府県", "市区", "町村","番地","建物名",
      "法人名","法人番号","法人住所", 
      "代表者性別","代表者名","代表者名カナ","代表者生年月日",
      "担当者性別","担当者名","担当者名カナ", "担当者生年月日",
      "連絡先1","連絡先2","メルアドレス","好適時間", "定休日",
      "dメル獲得日", "auPay獲得日", "PayPay獲得日", "楽天ペイ獲得日"
    ]
    columns = [
      "name","head_store","race", "industry",
      "prefecture", "city", "municipalities", "address","building_name",
      "corporate_name", "corporate_num","corporate_address",
      "gender_main","person_main_name","person_main_kana","person_main_birthday",
      "gender_sub","person_sub_name","person_sub_kana","person_sub_birthday",
      "phone_number_1","phone_number_2","mail_1","suitable_time","holiday",
      "dmer_date","aupay_date","paypay_date", "rakuten_pay_date"
    ]
    bom = "\uFEFF"
    csv = CSV.generate(bom) do |csv|
      csv << columns_ja
      @store_props_csv.find_each do |store|
          store_attriutes = store.attributes 
          if store.dmer.present?
            store_attriutes["dmer_date"] = store.dmer.date 
          else  
            store_attriutes["dmer_date"] = ""
          end
          if store.aupay.present?
            store_attriutes["aupay_date"] = store.aupay.date 
          else
            store_attriutes["aupay_date"] = "" 
          end
          if store.paypay.present?
            store_attriutes["paypay_date"] = store.paypay.date 
          else  
            store_attriutes["paypay_date"] = ""
          end 
          if store.rakuten_pay.present?
            store_attriutes["rakuten_pay_date"] = store.rakuten_pay.date
          else  
          store_attriutes["rakuten_pay_date"] = ""
          end 
          csv << store_attriutes.values_at(*columns)
        end
    end 
    create_csv(filename,csv)
  end 

  def show 
    @store_prop = StoreProp.find(params[:id])
    @dmer = @store_prop.dmer
    @aupay = @store_prop.aupay
    @paypay = @store_prop.paypay
    @praness = @store_prop.praness
    @rakuten_casa = @store_prop.rakuten_casa
    @st_insurance = @store_prop.st_insurance
    @rakuten_pay = @store_prop.rakuten_pay
    @demaekan = @store_prop.demaekan
    @summit_customer_prop = @store_prop.summit_customer_prop
    if @summit_customer_prop.nil?
      @summits = 0
    else  
      @summits = @summit_customer_prop.summits
    end

    @panda = @store_prop.pandas 
  end

  def destroy
    @store_prop = StoreProp.find(params[:id])
    @store_prop.destroy
    redirect_to store_props_path
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

  def back_retirement
    redirect_to error_pages_path if current_user.position == "退職"
  end

  def store_prop_params
    params.require(:store_prop).permit(
      :race,
      :name,
      :corporate_name,
      :corporate_address,
      :corporate_num,
      :industry,
      :gender_main, 
      :person_main_name, 
      :person_main_kana,
      :person_main_class,
      :person_main_birthday, 
      :gender_sub, 
      :person_sub_name, 
      :person_sub_kana, 
      :person_sub_class, 
      :person_sub_birthday, 
      :phone_number_1,
      :phone_number_2, 
      :mail_1,
      :mail_2,
      :prefecture, 
      :city, 
      :municipalities,
      :address, 
      :building_name, 
      :suitable_time, 
      :holiday,
      :head_store, 
      :description,
      )
    end 
  end
  