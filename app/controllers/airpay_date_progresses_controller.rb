class AirpayDateProgressesController < ApplicationController
  include CommonCalc
  before_action :authenticate_user!
  def index 
    @profit_price = CalcPeriod.where(sales_category: "実売").find_by(name: "AirPay成果1").price
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @create_date = params[:create_d]
    @date_group = AirpayDateProgress.pluck(:date).uniq
    @create_group = AirpayDateProgress.pluck(:create_date).uniq
    @users = User.all
    if params[:date].present?
      @month = params[:date].to_date
    elsif params[:search_date].present?
      @month = params[:search_date].to_date  
    elsif AirpayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date).present? 
      @month = AirpayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date)
    else
      @month = params[:month].to_date
    end 

    @current_progress = 
    AirpayDateProgress.includes(:user).where(date: @month)
    if params[:create_d].present?
      @current_progress = 
        @current_progress.where(create_date: params[:create_d].to_date)
    else
      @current_progress = 
      @current_progress.where(date: @month)
        .where(create_date: @current_progress.maximum(:create_date))
    end 
    # 拠点別現状売上
    @current_data_chubu = @current_progress.where(base: "中部SS")
    @current_data_kansai = @current_progress.where(base: "関西SS")
    @current_data_kanto = @current_progress.where(base: "関東SS")
    @current_data_kyushu = @current_progress.where(base: "九州SS")
    @current_data_partner = @current_progress.where(base: "2次店")
    @current_data_femto = @current_progress.where(base: "フェムト")
    @current_data_summit = @current_progress.where(base: "サミット")
    @current_data_retire = @current_progress.where(base: "退職")
    @current_arry = [
      @current_data_chubu,@current_data_kansai, @current_data_kanto, @current_data_kyushu,
      @current_data_partner,@current_data_femto, @current_data_summit, @current_data_retire
    ]
    if  @current_progress.present?
      # 折線グラフ
        @graph_bases = ["全体","2次店"]
        User.where("base LIKE ?","%SS%").group(:base).each do |user|
          @graph_bases << user.base
        end
        @data_fin = []
        @data_current = []
        @graph_bases.each do |base|
          if base == "全体"
            @data_fin << {
              name: "#{base}終着", 
              data: AirpayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
            }
            @data_current << {
              name: "#{base}現状売上", data: AirpayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
            }
          else  
            @data_fin << {
              name: "#{base}終着", 
              data: AirpayDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
            }
            @data_current << {
              name: "#{base}現状売上", data: AirpayDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
            }
          end 
        end
    else
      @data = AirpayDateProgress.none
    end

    # 比較対象
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
      @comparison = 
        AirpayDateProgress.where(date: @comparison_date)
      @comparison =
        @comparison.where(create_date: @comparison.maximum(:create_date))
    else  
      if @current_progress.present?
        @comparison = 
          AirpayDateProgress.where(date: @current_progress.first.date.prev_month)
        @comparison = 
          @comparison.where(create_date: @comparison.maximum(:create_date))
      else  
        @comparison = AirpayDateProgress.none
      end 
    end 
    # 拠点別現状売上
    @comparison_data_chubu = @comparison.where(base: "中部SS")
    @comparison_data_kansai = @comparison.where(base: "関西SS")
    @comparison_data_kanto = @comparison.where(base: "関東SS")
    @comparison_data_kyushu = @comparison.where(base: "九州SS")
    @comparison_data_partner = @comparison.where(base: "2次店")
    @comparison_data_femto = @comparison.where(base: "フェムト")
    @comparison_data_summit = @comparison.where(base: "サミット")
    @comparison_data_retire = @comparison.where(base: "退職")
    @comparison_arry = [
      @comparison_data_chubu,@comparison_data_kansai, @comparison_data_kanto, @comparison_data_kyushu,
      @comparison_data_partner,@comparison_data_femto, @comparison_data_summit, @comparison_data_retire
    ]
  end 

  def progress_create
    @month = params[:month].to_date
    if Date.today > @month
      @month = @month.end_of_month
    elsif Date.today < @month
      @month = @month.beginning_of_month
    else 
      @month = Date.today
    end 
    calc_profit
    airpay_calc_period = @calc_periods.find_by(name: "AirPay成果1")
    @airpay_bonus1_len = airpay_calc_period.bonus1_len
    @airpay_bonus2_len = airpay_calc_period.bonus2_len
    @airpay_bonus1_price = airpay_calc_period.bonus1_price
    @airpay_bonus2_price = airpay_calc_period.bonus2_price
    @airpay_price = airpay_calc_period.price
    @results = Result.includes(:result_cash).where(date: @start_date..@end_date).where(shift: "キャッシュレス新規")
    @shifts = Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
    # 全体終着獲得数
    @airpays_all_len_fin = 
      (@results.sum(:airpay).to_f / @results.length * @shifts.length).round() rescue 0
    # 実売単価
    @profit_price =
      if @airpays_all_len_fin >= @airpay_bonus2_len
        @airpay_bonus2_price
      elsif @airpays_all_len_fin >= @airpay_bonus1_len
        @airpay_bonus1_price
      else  
        @airpay_price
      end
    cnt = 0
    @airpays_group = Airpay.where(date: @month.ago(6.month).beginning_of_month..@month.end_of_month)
    @airpays_group.group(:user_id).each do |r|
      calc_profit
      @airpay1_start_date = start_date(airpay_calc_period)
      @airpay1_end_date = end_date(airpay_calc_period)
      @airpay1_closing_date = end_date(airpay_calc_period)
      @airpay1_this_month_per = airpay_calc_period.this_month_per
      @airpay1_prev_month_per = airpay_calc_period.prev_month_per
      user_id = r.user_id
      @airpay_progress_data = AirpayDateProgress.find_by(user_id: user_id,date: @month,create_date: Date.today)
      shift_schedule = @shifts.where(user_id: user_id).length
      shift_digestion = @results.where(user_id: user_id).length
    # 獲得内訳
      @airpays_user = Airpay.where(user_id: user_id)
      @airpays_user = 
        @airpays_user.where(status: "審査完了")
        .or(
          @airpays_user.where(status: "審査中")

        )
      @airpays_user_max = @airpays_user.where(client: "マックス").where(date: @start_date..@end_date)
      @airpays_user_max_fin_len = (@airpays_user_max.length.to_f / shift_digestion * shift_schedule).round() rescue 0
      result_len = @airpays_user.where(status: "審査完了").where(result_point: @airpay1_start_date..@airpay1_end_date).length
      @max_result_len = @airpays_user.where(client: "マックス").where(status: "審査完了").where(result_point: @airpay1_start_date..@airpay1_end_date).length
      @result_airpay_sum = @results.where(user_id: user_id).sum(:airpay) rescue 0
      @result_airpay_fin = (@result_airpay_sum.to_f / shift_digestion * shift_schedule).round() rescue 0
    # 現状売上
      valuation_current = 0
      profit_current = 0
    # 実売
      profit_current = (@profit_price * result_len) - (2000 * @max_result_len)
    # 終着
        # 26~末日までに審査完了
        airpays_done_result26_end_of_month_len = 
          @airpays_user.where(date: @start_date..@end_date).where(result_point: @start_date...@airpay1_start_date).where(status: "審査完了").length
        # 26〜来月末までに審査完了
        airpays_done_period_len = 
        @airpays_user.where(date: @start_date..@end_date).where(status: "審査完了")
        .where(result_point: @start_date..@airpay1_end_date).length
        period_fin_len = 
          ((@result_airpay_fin - airpays_done_result26_end_of_month_len).to_f * @airpay1_this_month_per).round() rescue 0
        # 期間内終着
        period_fin = @profit_price * period_fin_len
        # 過去月終着
        prev_len = (
            @airpays_user.where(status: "審査中")
            .where(date: ...@start_date).length.to_f * 
            @airpay1_prev_month_per
        ).round()
        prev_done = 
          @airpays_user.where(status: "審査完了")
          .where(date: ...@start_date)
          .where(result_point: @airpay1_start_date..@airpay1_end_date)
        prev_fin = 
          (@profit_price * prev_len) + 
          (@profit_price * prev_done.length)
        profit_fin = period_fin + prev_fin - (2000 * @max_result_len)
        result_fin_len =  ((period_fin + prev_fin) / @profit_price).round() rescue 0
        if (profit_current > profit_fin) || (Date.today > @airpay1_closing_date)
          profit_fin = profit_current
          result_fin_len = result_len
        end 
        calc_valuation
        @airpay_bonus1_len = airpay_calc_period.bonus1_len
        @airpay_bonus2_len = airpay_calc_period.bonus2_len
        @airpay_bonus1_price = airpay_calc_period.bonus1_price
        @airpay_bonus2_price = airpay_calc_period.bonus2_price
        @airpay1_start_date = start_date(airpay_calc_period)
        @airpay1_end_date = end_date(airpay_calc_period)
        @airpay1_closing_date = end_date(airpay_calc_period)
        @airpay1_this_month_per = airpay_calc_period.this_month_per
        @airpay1_prev_month_per = airpay_calc_period.prev_month_per
        @airpay_price = airpay_calc_period.price
      valuation_price =
        if @month >= Date.new(2023,7,1)
          8000
        else 
          if result_fin_len >= @airpay_bonus2_len
            @airpay_bonus2_price
          elsif result_fin_len >= @airpay_bonus1_len
            @airpay_bonus1_price
          else  
            @airpay_price
          end 
        end 
        period_fin_len = 
          (
            (@result_airpay_fin - airpays_done_result26_end_of_month_len).to_f *
            @airpay1_this_month_per
        ).round() rescue 0
        # 期間内終着
        period_fin = @profit_price * period_fin_len
        # 過去月終着
        prev_len = (
            @airpays_user.where(status: "審査中")
            .where(date: ...@start_date).length.to_f * 
            @airpay1_prev_month_per
        ).round()
        prev_done = 
          @airpays_user.where(status: "審査完了")
          .where(date: ...@start_date)
          .where(result_point: @airpay1_start_date..@airpay1_end_date)

      valuation_current = valuation_price * result_len
      period_fin = valuation_price * period_fin_len

      prev_fin = 
      (valuation_price * prev_len) + 
      (valuation_price * prev_done.length)

      valuation_fin = period_fin + prev_fin

      if (valuation_current > valuation_fin) || (Date.today > @airpay1_closing_date)
        valuation_fin = valuation_current
      end 

      if r.user.position == "退職"
        user_base = r.user.position
      elsif r.user.base_sub == "キャッシュレス"
        user_base = r.user.base
      else  
        user_base = "その他"
      end 

      # AirPayの売上の中身
      airpay_progress_params = {
        user_id: user_id                                    ,
        base: user_base                                     ,
        date: @month                                        ,
        shift_schedule: shift_schedule                      ,
        shift_digestion: shift_digestion                    ,
        get_len: @result_airpay_sum                         ,
        fin_len: @result_airpay_fin                         ,
        max_get_len: @airpays_user_max.length               ,
        max_fin_len: @airpays_user_max_fin_len              ,
        valuation_current: valuation_current                ,
        valuation_fin: valuation_fin                        ,
        profit_current: profit_current                      ,
        profit_fin: profit_fin                              ,
        result_len: result_len                              ,
        result_fin_len: result_fin_len                      ,
        max_result_len: @max_result_len                     ,
        create_date: Date.today
      }
    # 日付とユーザー名が一致しているデータの場合更新、新しいデータの場合保存
      if @airpay_progress_data.present?
        @airpay_progress_data.update(
          airpay_progress_params
        )
      else  
        @airpay_date_progress = AirpayDateProgress.new(
          airpay_progress_params
        )
        @airpay_date_progress.save
      end
      cnt += 1    
    end 
    redirect_to calc_periods_path(month: @month) ,alert: "#{cnt}件AirPay売上結果を作成しました"

  end

  def date_destroy
    @date_progress = AirpayDateProgress.where(date: params[:month]).where(create_date: params[:create_d])
    @date_progress.destroy_all
    redirect_to airpay_date_progresses_path(month: params[:month]), alert: "#{params[:create_d]}に作成した進捗を削除しました。"
   end

end
