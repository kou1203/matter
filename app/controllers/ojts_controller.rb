class OjtsController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @start_date = @month.prev_month.beginning_of_month.since(25.days)
    @end_date = @month.beginning_of_month.since(24.days)
    if params[:word].present?
      @start_date = params[:search_date].to_date.prev_month.beginning_of_month.since(25.days)
      @end_date = params[:search_date].to_date.beginning_of_month.since(24.days)
      @month = params[:search_date].to_date
      @user = User.where("name LIKE?","%#{params[:word]}%")
      @ojts = 
      Result.includes(:user,:result_cash)
      .where.not(ojt_id: nil)
      .where(date: @start_date..@end_date)
      .where.not(user: {base: "2次店"})
      .order(date: "ASC")
      .where(ojt_id: @user.first.id)
    else
      @ojts = 
        Result.includes(:user)
        .where.not(ojt_id: nil)
        .where(date: @start_date..@end_date)
        .where.not(user: {base: "2次店"})
        .order(date: "ASC")
    end
    @ojt_name = @ojts.pluck(:ojt_id).uniq
  end 

  def show 
    @ojt_date = Result.find(params[:result_id])
    @ojt_before = Result.includes(:user,:result_cash).where(user_id: @ojt_date.user_id).where("? > date",@ojt_date.date)
    if @ojt_date.date.day >= 26
    @start_date = @ojt_date.date.beginning_of_month.since(25.days)
    @end_date = @ojt_date.date.next_month.beginning_of_month.since(24.days)
  else  
    @start_date = @ojt_date.date.prev_month.beginning_of_month.since(25.days)
    @end_date = @ojt_date.date.beginning_of_month.since(24.days)
    end 
    @ojt_before = @ojt_before.last(3)
    @ojt_after = Result.where(user_id: @ojt_date.user_id).where("? < date",@ojt_date.date)
    @ojt_after = @ojt_after.first(3)
    @ojt_data = 
      Result.where(user_id: @ojt_date.user_id).where(date: @ojt_date.date.ago(3.days)..@ojt_date.date.since(3.days))
      .where(shift: "キャッシュレス新規")
    
      @results = 
        Result.includes(:user,:result_cash)
        .where(user_id: @ojt_date.user_id)
        .where(shift: "キャッシュレス新規")
        .where(date: @start_date..@end_date)
  end 

  def export 
    @results = Result.all
    @store_props_csv = StoreProp.includes(:dmer, :aupay, :paypay, :rakuten_pay)
    head :no_content
    filename = "店舗情報一覧#{Date.today}"
    
    columns_ja = [
      "氏名", "帯同者","エリア","日付","訪問", "応答", "対面","フル","成約",
      "dメル獲得数", "auPay獲得数", "楽天ペイ獲得数", "AirPay獲得数"
    ]
    columns = [
      "name","ojt","area","date","total_visit","visit","interview","full_talk","get",
      "dmer","aupay","rakuten_pay","airpay"
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
end
