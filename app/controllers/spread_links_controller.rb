class SpreadLinksController < ApplicationController
  before_action :authenticate_user!
  require 'google_drive'
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @spread_links = SpreadLink.where(year: @month.year, month: @month.month)
    @results = 
      Result.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month).group(:user_id)
    @bases = 
      Result.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month)
      .where.not(user: {position: "退職"}).group(:base)
  end 

  def export
    days = ["日", "月", "火", "水", "木", "金", "土"] 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @name = params[:name]
    @base = params[:base]
    @spread_links = SpreadLink.where(year: @month.year, month: @month.month)
    @spread_link = @spread_links.find_by("name LIKE ?","%#{@base}%")
    # GoogleDriveのセッションを取得する
    @session = GoogleDrive::Session.from_config("config.json")
    @session_data = @session.spreadsheet_by_key(@spread_link.search_url).worksheet_by_title(@name)
    @results = Result.includes(:user,:result_cash).where(user: {name: @name}).where(date: @month.beginning_of_month..@month.end_of_month).order(:date)
    @shifts = Shift.includes(:user).where(user: {name: @name}).where(start_time: @month.beginning_of_month..@month.end_of_month).order(:start_time)
    # 書き込むシートを指定する
    # スプレッドシートへの書き込み
    # @session_data[1, 2] = "Hello World"
    index_cnt = 0
    col_cnt = 0
    # 予定シフト
    # index_cnt = 4
    # @shifts.each do |shift|
    #   col_cnt = 6
    #   @session_data[col_cnt,index_cnt] = shift.shift
    #   index_cnt += 1
    # end 
    # 終着内容
    col_cnt = 5
    @shifts.zip(@results).each do |shift,result|
      index_cnt = 5 
      if shift.shift == "休み" || result.nil?
        @session_data[index_cnt,col_cnt] = shift.start_time.day
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = "（#{days[shift.start_time.wday]}）"
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = shift.shift.slice(-2,2)
        index_cnt += 1  
        col_cnt += 1
      else
        @session_data[index_cnt,col_cnt] = shift.start_time.day
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = "（#{days[shift.start_time.wday]}）"
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = shift.shift.slice(-2,2)
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.shift.slice(-2,2)
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.ojt.name rescue ""
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.area
        index_cnt += 2
        # 合計基準値
        @session_data[index_cnt,col_cnt] = result.first_total_visit.to_i + result.latter_total_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.first_visit.to_i + result.latter_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.first_interview.to_i + result.latter_interview.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.first_full_talk.to_i + result.latter_full_talk.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.first_get.to_i + result.latter_get.to_i
        index_cnt += 1
        # 前半基準値
        @session_data[index_cnt,col_cnt] = result.first_total_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.first_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.first_interview.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.first_full_talk.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.first_get.to_i
        index_cnt += 1
        # 後半基準値
        @session_data[index_cnt,col_cnt] = result.latter_total_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.latter_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.latter_interview.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.latter_full_talk.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.latter_get.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.cafe_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.cafe_get.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.other_food_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.other_food_get.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.car_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.car_get.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.other_retail_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.other_retail_get.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.hair_salon_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.hair_salon_get.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.manipulative_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.manipulative_get.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.other_service_visit.to_i
        index_cnt += 1
        @session_data[index_cnt,col_cnt] = result.other_service_get.to_i
        index_cnt += 1  
        if result.result_cash.present? 
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_01.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_01.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_01.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_02.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_02.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_02.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_03.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_03.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_03.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_04.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_04.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_04.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_05.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_05.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_05.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_06.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_06.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_06.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_07.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_07.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_07.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_08.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_08.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_08.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_09.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_09.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_09.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_10.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_10.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_10.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_11.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_11.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_11.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_12.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_12.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_12.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_interview_13.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_full_talk_13.to_i
          index_cnt += 1  
          @session_data[index_cnt,col_cnt] = result.result_cash.out_get_13.to_i
          index_cnt += 1  
        else  
          index_cnt += 42
        end 
        @session_data[index_cnt,col_cnt] = result.visit10.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.get10.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.visit11.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.get11.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.visit12.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.get12.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.visit13.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.get13.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.visit14.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.get14.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.visit15.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.get15.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.visit16.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.get16.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.visit17.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.get17.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.visit18.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.get18.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.visit19.to_i
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = result.get19.to_i
        index_cnt += 1  
        # 獲得商材
        @session_data[index_cnt,col_cnt] = Dmer.where(user_id: result.user_id).where(date: result.date).length rescue 0
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = Dmer.where(user_id: result.user_id).where(picture: result.date).length rescue 0
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = Dmer.where(user_id: result.user_id).where(settlement_second: result.date).length rescue 0
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = Aupay.where(user_id: result.user_id).where(date: result.date).length rescue 0
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = Aupay.where(user_id: result.user_id).where(picture: result.date).length rescue 0
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = Paypay.where(user_id: result.user_id).where(date: result.date).length rescue 0
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = RakutenPay.where(user_id: result.user_id).where(date: result.date).length rescue 0
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = Airpay.where(user_id: result.user_id).where(date: result.date).length rescue 0
        index_cnt += 1  
        @session_data[index_cnt,col_cnt] = Itss.where(user_id: result.user_id).where(date: result.date).length rescue 0
        index_cnt += 1  

        col_cnt += 1 # 列を一列ずらす
      end
    end 
      @session_data.save
      redirect_to spread_links_path(month: @month), alert: "スプレッドへ書き込みました！"
  end 

  def new 
    @spread_link = SpreadLink.new
  end 

  def create 
    @spread_link = SpreadLink.new(spread_links_params)
    if @spread_link.save 
      flash[:notice] = "スプレッド情報を保存しました。"

      redirect_to spread_links_path(month: @month)
      
    else 
    end 
  end 
  
  def show 
  end 

  private 
  def spread_links_params
    params.require(:spread_link).permit(
      :year,
      :month,
      :name,
      :original_url,
      :search_url,
    )
  end 
  
end
