class OjtsController < ApplicationController
  require 'csv'
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @start_date = @month.beginning_of_month
    @end_date = @month.end_of_month
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
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @start_date = @month.prev_month.beginning_of_month.since(25.days)
    @end_date = @month.beginning_of_month.since(24.days)
    @date_period = (@start_date.to_date..@end_date.to_date)
    @ojts = Result.includes(:user).where(date: @start_date..@end_date).where.not(ojt_id: nil).where.not(user: {base: "2次店"})
    @users = @ojts.pluck(:user_id).uniq
    @results = Result.includes(:user,:result_cash).where(date: @start_date..@end_date).where.not(user: {base: "2次店"})
    head :no_content
    filename = "帯同資料用利益表"
    
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
      @users.each do |user|
        if @results.where(ojt_id: user).length  == 0
          @date_period.each do |date|
            results = @results.where(user_id: user)
              result = results.find_by(date: date)
              if result.present? 
                result_attributes = result.attributes
                result_attributes["name"] = result.user.name
                if result.ojt.present?
                result_attributes["ojt"] = result.ojt.name
                end 
                result_attributes["area"] = result.area
                result_attributes["date"] = result.date
                result_attributes["total_visit"] = result.first_total_visit.to_i + result.latter_total_visit.to_i
                result_attributes["visit"] = result.first_visit.to_i + result.latter_visit.to_i
                result_attributes["interview"] = result.first_interview.to_i + result.latter_interview.to_i
                result_attributes["full_talk"] = result.first_full_talk.to_i + result.latter_full_talk.to_i
                result_attributes["get"] = result.first_get.to_i + result.latter_get.to_i
                if result.result_cash.present?
                  result_attributes["dmer"] = result.result_cash.dmer.to_i
                  result_attributes["aupay"] = result.result_cash.aupay.to_i
                  result_attributes["rakuten_pay"] = result.result_cash.rakuten_pay.to_i
                  result_attributes["airpay"] = result.result_cash.airpay.to_i
                end
              else 
                result_attributes = {}
                result_attributes["name"] = User.find_by(id: user).name
                result_attributes["date"] = date.strftime("%y-%m-%d")
              end 
            csv << result_attributes.values_at(*columns)
          end 
        end
      end
    end 
    create_csv(filename,csv)
  end 

  def summary_export 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @start_date = @month.prev_month.beginning_of_month.since(25.days)
    @end_date = @month.beginning_of_month.since(24.days)
    @date_period = (@start_date.to_date..@end_date.to_date)
    @ojts = Result.includes(:user).where(date: @start_date..@end_date).where.not(ojt_id: nil).where.not(user: {base: "2次店"})
    @ojt_name = @ojts.pluck(:ojt_id).uniq
    @results = Result.includes(:user,:result_cash).where(date: @start_date..@end_date).where.not(user: {base: "2次店"})
    head :no_content
    filename = "帯同結果早見"
    
    columns_ja = [
      "帯同者", "帯同数","訪問", "応答", "対面","フル","成約",
      "dメル獲得数", "auPay獲得数", "楽天ペイ獲得数", "AirPay獲得数"
    ]
    columns = [
      "name","ojt_len","total_visit","visit","interview","full_talk","get",
      "dmer","aupay","rakuten_pay","airpay"
    ]
    bom = "\uFEFF"
    csv = CSV.generate(bom) do |csv|
      csv << columns_ja
      @ojt_name.each do |ojt|
          ojts = @ojts.includes(:result_cash).where(ojt_id: ojt).where.not(user_id: ojt)
                result_attributes = {}
                result_attributes["name"] = User.find_by(id: ojt).name
                result_attributes["ojt_len"] = ojts.length
                result_attributes["total_visit"] = ((ojts.sum(:first_total_visit) + ojts.sum(:latter_total_visit)).to_f / ojts.length).round(1)
                result_attributes["visit"] = ((ojts.sum(:first_visit) + ojts.sum(:latter_visit)) / ojts.length).round(1)
                result_attributes["interview"] = ((ojts.sum(:first_interview) + ojts.sum(:latter_interview)).to_f / ojts.length).round(1)
                result_attributes["full_talk"] = ((ojts.sum(:first_full_talk) + ojts.sum(:latter_full_talk)).to_f / ojts.length).round(1)
                result_attributes["get"] = ((ojts.sum(:first_get) + ojts.sum(:latter_get)).to_f / ojts.length).round(1)
                  result_attributes["dmer"] = (ojts.sum(:dmer).to_f / ojts.length).round(1)
                  result_attributes["aupay"] = (ojts.sum(:aupay).to_f / ojts.length).round(1)
                  result_attributes["rakuten_pay"] = (ojts.sum(:rakuten_pay).to_f / ojts.length).round(1)
                  result_attributes["airpay"] = (ojts.sum(:airpay).to_f / ojts.length).round(1)
            csv << result_attributes.values_at(*columns)
      end
    end 
    create_csv(filename,csv)
  end 

  def index_export
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @start_date = @month.prev_month.beginning_of_month.since(25.days)
    @end_date = @month.beginning_of_month.since(24.days)
    @date_period = (@start_date..@end_date)
    @ojts = 
      Result.includes(:user)
      .where.not(ojt_id: nil)
      .where(date: @start_date..@end_date)
      .where.not(user: {base: "2次店"})
      .order(date: "ASC")
    @users = @ojts.pluck(:user_id).uniq
    @results = Result.includes(:user,:result_cash).where(date: @start_date..@end_date).where.not(user: {base: "2次店"})
    head :no_content
    filename = "帯同結果一覧"
    
    columns_ja = [
      "拠点","氏名", "帯同者","項目","日付","エリア","訪問", "応答", "対面","フル","成約",
      "dメル獲得数", "auPay獲得数", "楽天ペイ獲得数", "AirPay獲得数","帯同開始","帯同終了"
    ]
    columns = [
      "base","name","ojt","section","date","area","total_visit","visit","interview","full_talk","get",
      "dmer","aupay","rakuten_pay","airpay","ojt_start","ojt_end"
    ]
    bom = "\uFEFF"
    csv = CSV.generate(bom) do |csv|
      csv << columns_ja
      @ojts.each do |ojt|
        ojt_attributes = ojt.attributes
        unless ojt.user_id == ojt.ojt_id
          ojt_attributes["base"] = ojt.user.base 
          ojt_attributes["name"] = ojt.user.name 
          if ojt.ojt.present?
          ojt_attributes["ojt"] = ojt.ojt.name
          end
          ojt_attributes["section"] = "帯同日" 
          ojt_attributes["date"] = ojt.date
          ojt_attributes["area"] = ojt.area
          ojt_attributes["total_visit"] = ojt.area
          ojt_attributes["total_visit"] = ojt.first_total_visit.to_i + ojt.latter_total_visit.to_i
          ojt_attributes["visit"] = ojt.first_visit.to_i + ojt.latter_visit.to_i
          ojt_attributes["interview"] = ojt.first_interview.to_i + ojt.latter_interview.to_i
          ojt_attributes["full_talk"] = ojt.first_full_talk.to_i + ojt.latter_full_talk.to_i
          ojt_attributes["get"] = ojt.first_get.to_i + ojt.latter_get.to_i
          if ojt.result_cash.present?
            ojt_attributes["dmer"] = ojt.result_cash.dmer.to_i
            ojt_attributes["aupay"] = ojt.result_cash.aupay.to_i
            ojt_attributes["rakuten_pay"] = ojt.result_cash.rakuten_pay.to_i
            ojt_attributes["airpay"] = ojt.result_cash.airpay.to_i
          end
          ojt_attributes["ojt_start"] = ojt.ojt_start
          ojt_attributes["ojt_end"] = ojt.ojt_end
          csv << ojt_attributes.values_at(*columns) if ojt_attributes["name"].present?

          # 帯同前
          ojt_before = Result.includes(:user,:result_cash).where(user_id: ojt.user_id).where("? > date",ojt.date).last(3)
          before_total_visit = ((ojt_before.sum {|hash| hash[:first_total_visit].to_f} + ojt_before.sum {|hash| hash[:latter_total_visit].to_f}).to_f / ojt_before.length).round(1)
          before_visit = ((ojt_before.sum {|hash| hash[:first_visit].to_f} + ojt_before.sum {|hash| hash[:latter_visit].to_f}).to_f / ojt_before.length).round(1)
          before_interview = ((ojt_before.sum {|hash| hash[:first_interview].to_f} + ojt_before.sum {|hash| hash[:latter_interview].to_f}).to_f / ojt_before.length).round(1)
          before_full_talk = ((ojt_before.sum {|hash| hash[:first_full_talk].to_f} + ojt_before.sum {|hash| hash[:latter_full_talk].to_f}).to_f / ojt_before.length).round(1)
          before_get = ((ojt_before.sum {|hash| hash[:first_get].to_f} + ojt_before.sum {|hash| hash[:latter_get].to_f}).to_f / ojt_before.length).round(1) 
          before_dmer = (ojt_before.sum {|hash| hash.result_cash[:dmer].to_f} / ojt_before.length).round(1) rescue 0 
          before_aupay = (ojt_before.sum {|hash| hash.result_cash[:aupay].to_f} / ojt_before.length).round(1) rescue 0
          before_rakuten_pay = (ojt_before.sum {|hash| hash.result_cash[:rakuten_pay].to_f} / ojt_before.length).round(1) rescue 0
          before_airpay = (ojt_before.sum {|hash| hash.result_cash[:airpay].to_f} / ojt_before.length).round(1) rescue 0 
          ojt_attributes = ojt.attributes
          ojt_attributes["base"] = ojt.user.base 
          ojt_attributes["name"] = ojt.user.name 
          ojt_attributes["section"] = "帯同前" 
          ojt_attributes["date"] = "#{ojt_before.first.date.strftime("%m/%d")}〜#{ojt_before.last.date.strftime("%m/%d")}" if ojt_before.length != 0
          ojt_attributes["area"] = ojt.area
          ojt_attributes["total_visit"] = before_total_visit
          ojt_attributes["visit"] = before_visit
          ojt_attributes["interview"] = before_interview
          ojt_attributes["full_talk"] = before_full_talk
          ojt_attributes["get"] = before_get
          if ojt.result_cash.present?
            ojt_attributes["dmer"] = before_dmer
            ojt_attributes["aupay"] = before_aupay
            ojt_attributes["rakuten_pay"] = before_rakuten_pay
            ojt_attributes["airpay"] = before_airpay
          end
          csv << ojt_attributes.values_at(*columns) if ojt_attributes["name"].present?

          # 帯同後
          ojt_after = Result.where(user_id: ojt.user_id).where("? < date",ojt.date).first(3)
          after_total_visit = ((ojt_after.sum {|hash| hash[:first_total_visit].to_f} + ojt_after.sum {|hash| hash[:latter_total_visit].to_f}).to_f / ojt_after.length).round(1)
          after_visit = ((ojt_after.sum {|hash| hash[:first_visit].to_f} + ojt_after.sum {|hash| hash[:latter_visit].to_f}).to_f / ojt_after.length).round(1)
          after_interview = ((ojt_after.sum {|hash| hash[:first_interview].to_f} + ojt_after.sum {|hash| hash[:latter_interview].to_f}).to_f / ojt_after.length).round(1)
          after_full_talk = ((ojt_after.sum {|hash| hash[:first_full_talk].to_f} + ojt_after.sum {|hash| hash[:latter_full_talk].to_f}).to_f / ojt_after.length).round(1)
          after_get = ((ojt_after.sum {|hash| hash[:first_get].to_f} + ojt_after.sum {|hash| hash[:latter_get].to_f}).to_f / ojt_after.length).round(1)
          after_dmer = (ojt_after.sum {|hash| hash.result_cash[:dmer].to_f} / ojt_after.length).round(1) rescue 0
          after_aupay = (ojt_after.sum {|hash| hash.result_cash[:aupay].to_f} / ojt_after.length).round(1) rescue 0
          after_rakuten_pay = (ojt_after.sum {|hash| hash.result_cash[:rakuten_pay].to_f} / ojt_after.length).round(1) rescue 0
          after_airpay = (ojt_after.sum {|hash| hash.result_cash[:airpay].to_f} / ojt_after.length).round(1) rescue 0
          ojt_attributes = ojt.attributes
          ojt_attributes["base"] = ojt.user.base 
          ojt_attributes["name"] = ojt.user.name 
          ojt_attributes["section"] = "帯同後" 
          ojt_attributes["date"] = "#{ojt_after.first.date.strftime("%m/%d")}〜#{ojt_after.last.date.strftime("%m/%d")}" if ojt_after.length != 0
          ojt_attributes["area"] = ojt.area
          ojt_attributes["total_visit"] = ojt.area
          ojt_attributes["total_visit"] = after_total_visit
          ojt_attributes["visit"] = after_visit
          ojt_attributes["interview"] = after_interview
          ojt_attributes["full_talk"] = after_full_talk
          ojt_attributes["get"] = after_get
          if ojt.result_cash.present?
            ojt_attributes["dmer"] = after_dmer
            ojt_attributes["aupay"] = after_aupay
            ojt_attributes["rakuten_pay"] = after_rakuten_pay
            ojt_attributes["airpay"] = after_airpay
          end
          csv << ojt_attributes.values_at(*columns) if ojt_attributes["name"].present?

        end 


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
end
