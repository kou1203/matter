class SpreadLinksController < ApplicationController
  before_action :authenticate_user!
  require 'google_drive'
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @spread_links = SpreadLink.where(year: @month.year, month: @month.month)
    @results = 
      Result.includes(:user).where(date: @month.beginning_of_month..@month.end_of_month).where.not(user: {position: "退職"}).group(:user_id)
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
    @results = Result.includes(:user).where(user: {name: @name}).where(date: @month.beginning_of_month..@month.end_of_month).order(:date)
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
        index_cnt += 1
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
