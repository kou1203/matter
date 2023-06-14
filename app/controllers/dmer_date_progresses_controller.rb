class DmerDateProgressesController < ApplicationController

  def index # index start
    @profit_price1 = CalcPeriod.where(sales_category: "実売").find_by(name: "dメル成果1").price
    @profit_price2 = CalcPeriod.where(sales_category: "実売").find_by(name: "dメル成果2").price
    @profit_price3 = CalcPeriod.where(sales_category: "実売").find_by(name: "dメル成果3").price
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @create_date = params[:create_d]
    @date_group = DmerDateProgress.pluck(:date).uniq
    @create_group = DmerDateProgress.pluck(:create_date).uniq
    @users = User.all
    if params[:date].present? # 検索
      @month = params[:date].to_date
    elsif params[:search_date].present?
      @month = params[:search_date].to_date  
    elsif DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date).present? 
      @month = DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date)
    else
      @month = params[:month].to_date
    end # /検索
    # 全体現状売上
      @current_progress = 
        DmerDateProgress.includes(:user).where(date: @month)
      if params[:create_d].present?
        @current_progress = 
          @current_progress.where(create_date: params[:create_d].to_date)
      else
        @current_progress = 
        @current_progress.where(date: @month)
          .where(create_date: @current_progress.maximum(:create_date))
      end 
    # /全体現状売上
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
    # /拠点別現状売上
    if  @current_progress.present? # 今日、もしくは検索した日付のデータがあるか？
      @graph_bases = ["全体","2次店"]
      User.where("base LIKE ?","%SS%").group(:base).each do |user|
        @graph_bases << user.base
      end
      @result1_graph = []
      @result2_graph = []
      @result3_graph = []
      @data_fin = []
      @data_current = []
      @graph_bases.each do |base|
        if base == "全体"
          @data_fin << {
            name: "#{base}終着", 
            data: DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum("profit_fin1+profit_fin2+profit_fin3")
          }
          @data_current << {
            name: "#{base}現状売上", data: DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
          }
          @result1_graph << {
            name: "#{base}一次成果になった件数", data: DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:result1_len)
          }
          @result2_graph << {
            name: "#{base}二次成果になった件数", data: DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:result2_len)
          }
          @result3_graph << {
            name: "#{base}三次成果になった件数", data: DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:result3_len)
          }
        else  
          @data_fin << {
            name: "#{base}終着", 
            data: DmerDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum("profit_fin1+profit_fin2+profit_fin3")
          }
          @data_current << {
            name: "#{base}現状売上", data: DmerDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
          }
          @result1_graph << {
            name: "#{base}一次成果になった件数", data: DmerDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:result1_len)
          }
          @result2_graph << {
            name: "#{base}二次成果になった件数", data: DmerDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:result2_len)
          }
          @result3_graph << {
            name: "#{base}三次成果になった件数", data: DmerDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:result3_len)
          }
        end
      end
    else
      @data = DmerDateProgress.none
    end
    # 比較対象
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
      @comparison = 
        DmerDateProgress.where(date: @comparison_date)
      @comparison =
        @comparison.where(create_date: @comparison.maximum(:create_date))
    else  
      if @current_progress.present?
        @comparison = 
          DmerDateProgress.where(date: @current_progress.first.date.prev_month)
        @comparison = 
          @comparison.where(create_date: @comparison.maximum(:create_date))
      else  
        @comparison = DmerDateProgress.none
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
  end # index end

 def progress_create
  @month = params[:month].to_date
  if Date.today > @month
    @month = @month.end_of_month
  elsif Date.today < @month
    @month = @month.beginning_of_month
  else 
    @month = Date.today
  end 
  @calc_periods = CalcPeriod.where(sales_category: "実売")
  calc_period_and_per
  @results = Result.where(date: @start_date..@end_date).where(shift: "キャッシュレス新規")
  @results_slmt = Result.where(date: @start_date..@end_date).where(shift: "キャッシュレス決済")
  @shifts = Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
  @shifts_slmt = Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス決済")
  cnt = 0
  @dmers_group = Shift.group(:user_id)
  @dmers_group.group(:user_id).each do |r|
    @calc_periods = CalcPeriod.where(sales_category: "実売")
    calc_period_and_per
    user_id = r.user_id
    @dmer_progress_data = DmerDateProgress.find_by(user_id: user_id,date: @month,create_date: Date.today)
    shift_schedule = @shifts.where(user_id: user_id).length
    shift_digestion = @results.where(user_id: user_id).length
    shift_schedule_slmt = @shifts_slmt.where(user_id: user_id).length
    shift_digestion_slmt = @results_slmt.where(user_id: user_id).length
  # 獲得内訳
    @dmers_user = Dmer.where(user_id: user_id)
    @dmers_slmter = Dmer.where(settlementer_id: user_id)
    @dmers_user_period = @dmers_user.where(date: @start_date..@end_date)
    # 申込取消or不備対応中or審査NGor社内確認中
    @dmers_user_def = 
      @dmers_user_period.where(status: "審査NG")
      .or(
        @dmers_user_period.where(status: "申込取消")
      )
      .or(
        @dmers_user_period.where(status: "不備対応中")
      )
      .or(
        @dmers_user_period.where(status: "社内確認中")
      )
    # 不備・NGを引いた獲得数
    @dmers_len = @dmers_user_period.length - @dmers_user_def.length
    @dmers_fin_len = (@dmers_len.to_f / shift_digestion * shift_schedule).round() rescue 0
    # 審査待ち
    dmer_wait = @dmers_user_period.where(status: "審査待ち")
    dmer_wait_prev = @dmers_user.where(status: "審査待ち").where(date: @start_date.prev_month...@start_date)
    # 審査完了
    dmer_done = 
      @dmers_user.where(result_point: @dmer1_start_date..@dmer1_end_date)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    dmer_done_period = dmer_done.where(date: @start_date..@end_date)
    dmer_done_prev = dmer_done.where(date: ...@start_date)
    # 過去月の決済対象
    dmer_slmt_tgt_prev = 
    @dmers_user.where(settlement_deadline: @start_date.. )
    .where(date: ...@start_date)
    .where(status: "審査OK")
    .where.not(industry_status: "×")
    .where.not(industry_status: "NG")
    .where.not(industry_status: "要確認")
    .where(settlement: nil)
    .or(
      @dmers_user.where(settlement_deadline: @start_date.. )
      .where(date: ...@start_date)
      .where(status: "審査OK")
      .where.not(industry_status: "×")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "要確認")
      .where(settlement: @dmer1_start_date..@dmer1_end_date)
    )
    dmer_slmt_tgt_prev_len = dmer_slmt_tgt_prev.length rescue 0
  # 決済期限切れ
    dmer_slmt_dead_len = dmer_slmt_tgt_prev.where(status_settlement: "期限切れ").length
  # 現状売上
    valuation_current = 0
    profit_current = 0
  # 実売
    dmer_result1 = 
    @dmers_slmter.where(result_point: @dmer1_start_date..@dmer1_end_date)
    .where(settlement: ..@dmer1_end_date)
    .where(app_check_date: ..@dmer1_end_date)
    .where(status: "審査OK")
    .where.not(industry_status: "NG")
    .where.not(industry_status: "×")
    .where.not(industry_status: "要確認")
    .or(
      @dmers_slmter.where(settlement: @dmer1_start_date..@dmer1_end_date)
      .where(result_point: ..@dmer1_end_date)
      .where(app_check_date: ..@dmer1_end_date)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    )
    .or(
      @dmers_slmter.where(settlement: ...@dmer1_start_date)
      .where(result_point: ...@dmer1_end_date)
      .where(app_check_date: @dmer1_start_date..@dmer1_end_date)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    ).or(
      @dmers_slmter.where(result_point: @dmer1_start_date..@dmer1_end_date)
    .where(settlement: ..@dmer1_end_date)
    .where(app_check: "OK")
    .where(status: "審査OK")
    .where.not("client LIKE ?", "%ぷらいまる%")
    .where.not(industry_status: "NG")
    .where.not(industry_status: "×")
    .where.not(industry_status: "要確認")
    ).or(
      @dmers_slmter.where(settlement: @dmer1_start_date..@dmer1_end_date)
      .where(result_point: ..@dmer1_end_date)
      .where(app_check: "OK")
      .where(status: "審査OK")
      .where.not("client LIKE ?", "%ぷらいまる%")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    )
    dmer_result1_period = dmer_result1.where(date: @start_date..@end_date)
    dmer_result1_prev = dmer_result1.where(date: ...@start_date)
  # 成果2
    dmer_slmt_done = 
      @dmers_slmter.where(status_update_settlement: @dmer2_start_date..@dmer2_end_date)
      .where(result_point: ..@dmer2_end_date)
      .where(status_settlement: "完了").where(app_check_date: ..@dmer2_end_date)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      .or(
      @dmers_slmter.where(status_update_settlement: ..@dmer2_end_date)
      .where(result_point: @dmer2_start_date..@dmer2_end_date)
      .where(status_settlement: "完了").where(app_check_date: ..@dmer2_end_date)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    )
    .or(
        @dmers_slmter.where(status_update_settlement: ...@dmer2_start_date)
        .where(result_point: ...@dmer2_start_date)
        .where(status_settlement: "完了").where(app_check_date: @dmer2_start_date..@dmer2_end_date)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
    ).or(
      @dmers_slmter.where(status_update_settlement: @dmer2_start_date..@dmer2_end_date)
      .where(result_point: ...@dmer2_start_date)
      .where(status_settlement: "完了").where(app_check: "OK")
      .where.not("client LIKE ?", "%ぷらいまる%")
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    ).or(
      @dmers_slmter.where(status_update_settlement: ...@dmer2_start_date)
      .where(result_point: @dmer2_start_date..@dmer2_end_date)
      .where(status_settlement: "完了").where(app_check: "OK")
      .where.not("client LIKE ?", "%ぷらいまる%")
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    )
      dmer_slmt_done_period = dmer_slmt_done.where(date: @start_date..@end_date)
      dmer_slmt_done_prev = dmer_slmt_done.where(date: ...@start_date)
  # 成果3
    dmer_slmt2nd_done = 
      @dmers_slmter.where(settlement_second: @dmer3_start_date..@dmer3_end_date)
      .where("? >= status_update_settlement", @dmer3_end_date)
      .where(app_check_date: ..@dmer3_end_date)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      .where(status_settlement: "完了")
      .or(
        @dmers_slmter
        .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
        .where("? >= settlement_second", @dmer3_end_date)
        .where(app_check_date: ..@dmer3_end_date)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
      ).or(
        @dmers_slmter
        .where(result_point: @dmer3_start_date..@dmer3_end_date)
        .where(status_update_settlement: ...@dmer3_start_date)
        .where(settlement_second: ...@dmer3_start_date)
        .where(app_check_date: ...@dmer3_start_date)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
      ).or(
        @dmers_slmter
        .where(status_update_settlement: ...@dmer3_start_date)
        .where(settlement_second: ...@dmer3_start_date)
        .where(app_check_date: @dmer3_start_date..@dmer3_end_date)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
      ).or(
        @dmers_slmter.where(settlement_second: @dmer3_start_date..@dmer3_end_date)
        .where("? >= status_update_settlement", @dmer3_end_date)
        .where(app_check: "OK")
        .where.not("client LIKE ?", "%ぷらいまる%")
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
      ).or(
        @dmers_slmter
        .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
        .where("? >= settlement_second", @dmer3_end_date)
        .where(status: "審査OK")
        .where(app_check: "OK")
        .where.not("client LIKE ?", "%ぷらいまる%")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
      )
      dmer_slmt2nd_done_period = dmer_slmt2nd_done.where(date: @start_date..@end_date)
      dmer_slmt2nd_done_prev = dmer_slmt2nd_done.where(date: ...@start_date)
      # 実売
      profit_current1_price = dmer_result1.sum(:profit_new)
      profit_current2_price = dmer_slmt_done.sum(:profit_settlement)
      profit_current3_price = dmer_slmt2nd_done.sum(:profit_second_settlement)
      # 26~25までの獲得で前月中に成果に至っているデータ
      already_done1 = 
        @dmers_user_period.where(result_point: ..@dmer1_start_date)
        .where(settlement: ...@dmer1_start_date)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
      already_done2 = already_done1.where(status_settlement: "完了").where(status_update_settlement: ...@dmer2_start_date)
      already_done3 = already_done2.where(settlement_second: ...@dmer3_start_date)
      # 過去月の成果対象母体
      result_tgt_prev1 = dmer_slmt_tgt_prev.where(settlement: nil).where.not(status_settlement: "期限切れ")
      result_tgt_prev2 = dmer_slmt_tgt_prev.where(status_update_settlement: nil).where.not(status_settlement: "期限切れ")
      
      # 実売終着1（期内）
      if shift_digestion == 0 || shift_schedule == 0
        profit_fin1_period_len = 0
        profit_fin1_period = 0
      else  
        profit_fin1_period_len = ((@dmers_len - dmer_result1_period.length).to_f / shift_digestion * shift_schedule * @dmer1_this_month_per).round()
        profit_fin1_period = (@dmer1_price * profit_fin1_period_len) - already_done1.sum(:profit_new) + (@dmer1_price * (dmer_result1_period.length.to_f * @dmer1_this_month_per).round())
      end 
      # 実売終着1（過去）
      profit_fin1_prev = 
        (@dmer1_price * ( result_tgt_prev1.length.to_f * @dmer1_prev_month_per).round()) +
        dmer_result1_prev.sum(:profit_new)
      profit_fin1 = profit_fin1_period + profit_fin1_prev
        if (Date.today > @dmer1_closing_date) || (profit_current1_price > profit_fin1)
          profit_fin1 = profit_current1_price
        end 
      # 実売終着2（期内）
      if shift_digestion == 0 || shift_schedule == 0
        profit_fin2_period_len = 0
        profit_fin2_period = 0
      else  
        profit_fin2_period_len = ((@dmers_len - dmer_slmt_done_period.length).to_f / shift_digestion * shift_schedule * @dmer2_this_month_per).round()
        profit_fin2_period = (@dmer2_price * profit_fin2_period_len) - already_done2.sum(:profit_settlement) + (@dmer2_price * (dmer_slmt_done_period.length.to_f * @dmer2_this_month_per).round())
      end  
      # 実売終着2（過去）
      profit_fin2_prev = 
        (@dmer2_price * (result_tgt_prev2.length.to_f * @dmer2_prev_month_per).round()) +
        dmer_slmt_done_prev.sum(:profit_settlement)
        profit_fin2 = profit_fin2_period + profit_fin2_prev
        if (Date.today > @dmer2_closing_date) || (profit_current2_price > profit_fin2)
          profit_fin2 = profit_current2_price
        end 
      # 実売終着3（期内）
      if shift_digestion == 0 || shift_schedule == 0
        profit_fin3_period_len = 0
        profit_fin3_period = 0
      else  
        profit_fin3_period_len = ((@dmers_len - dmer_slmt2nd_done_period.length).to_f / shift_digestion * shift_schedule * @dmer3_this_month_per).round()
        profit_fin3_period = (@dmer3_price * profit_fin3_period_len) - already_done3.sum(:profit_second_settlement) + (@dmer3_price * (dmer_slmt2nd_done_period.length.to_f * @dmer3_this_month_per).round())
      end 
      # 実売終着3（過去）
      # 26~次の月の月末までに成果になっている案件
      slmt2nd26_next_month_end_of_month_done = 
        dmer_slmt_tgt_prev.where(settlement_second: ..@dmer3_end_date)
        .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
        .where(status_settlement: "完了")
        .or(
          dmer_slmt_tgt_prev.where(status_update_settlement: ..@dmer3_end_date)
          .where(settlement_second: @dmer3_start_date..@dmer3_end_date)
          .where(status_settlement: "完了")
        )
      profit_fin3_len = (
        (dmer_slmt_tgt_prev.length - slmt2nd26_next_month_end_of_month_done.length - dmer_slmt_dead_len).to_f * 
        @dmer3_prev_month_per
      ).round()
      profit_fin3_prev = 
        (@dmer3_price * profit_fin3_len) + dmer_slmt2nd_done_prev.sum(:profit_second_settlement)
        profit_fin3 = profit_fin3_period + profit_fin3_prev
        if (Date.today > @dmer3_closing_date) || (profit_current3_price > profit_fin3)
          profit_fin3 = profit_current3_price
        end 

       result1_fin_len = profit_fin1 / @dmer1_price
       result2_fin_len = profit_fin2 / @dmer2_price
       result3_fin_len = profit_fin3 / @dmer3_price

      # 評価売
      @calc_periods = CalcPeriod.where(sales_category: "評価売")
      calc_period_and_per
      valuation_current1_price = dmer_done.sum(:valuation_new)
      # 成果2
      dmer_slmt_done = 
      @dmers_slmter.where(status_update_settlement: @dmer2_start_date..@dmer2_end_date)
      .where(result_point: ..@dmer2_end_date)
      .where(status_settlement: "完了").where(app_check: "OK")
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      .or(
      @dmers_slmter.where(status_update_settlement: ..@dmer2_end_date)
      .where(result_point: @dmer2_start_date..@dmer2_end_date)
      .where(status_settlement: "完了").where(app_check: "OK")
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    )
      # 成果3
      dmer_slmt2nd_done = 
      @dmers_slmter.where(settlement_second: @dmer3_start_date..@dmer3_end_date)
      .where("? >= status_update_settlement", @dmer3_end_date)
      .where(app_check: "OK")
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      .where(status_settlement: "完了")
      .or(
        @dmers_slmter
        .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
        .where("? >= settlement_second", @dmer3_end_date)
        .where(app_check: "OK")
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
      ).or(
        @dmers_slmter
        .where(result_point: @dmer3_start_date..@dmer3_end_date)
        .where(status_update_settlement: ...@dmer3_start_date)
        .where(settlement_second: ...@dmer3_start_date)
        .where(app_check: "OK")
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
      )
      valuation_current2_price = dmer_slmt_done.sum(:valuation_settlement)
      valuation_current3_price = dmer_slmt2nd_done.sum(:valuation_second_settlement)

      already_val_done1 = 
        @dmers_user_period.where(result_point: @start_date..@dmer1_start_date)
        .where(status: "審査OK").where.not(industry_status: "NG")
        .where.not(industry_status: "×").where.not(industry_status: "要確認")     
      # 実売終着1（期内）
      if shift_digestion == 0 || shift_schedule == 0
        valuation_fin1_period_len = 0
        valuation_fin1_period = 0
      else  
        valuation_fin1_period_len = ((@dmers_len - dmer_done_period.length).to_f / shift_digestion * shift_schedule * (@dmer1_this_month_per - @dmer1_dec_per)).round()
        valuation_fin1_period = (@dmer1_price * valuation_fin1_period_len) - already_val_done1.sum(:valuation_new) + dmer_done_period.sum(:valuation_new)
      end  
      # 実売終着1（過去）
      valuation_fin1_prev = 
        (@dmer1_price * (dmer_wait_prev.length.to_f * (@dmer1_prev_month_per - @dmer1_prev_dec_per)).round()) +
        dmer_result1_prev.sum(:valuation_new)
        valuation_fin1 = valuation_fin1_period + valuation_fin1_prev
        if (Date.today > @dmer1_closing_date) || (valuation_current1_price > valuation_fin1)
          valuation_fin1 = valuation_current1_price
        end 
      # 実売終着2（期内）
      if shift_digestion == 0 || shift_schedule == 0
        valuation_fin2_period_len = 0
        valuation_fin2_period = 0
      else  
        valuation_fin2_period_len = ((@dmers_len - dmer_slmt_done_period.length).to_f / shift_digestion * shift_schedule * (@dmer2_this_month_per - @dmer2_dec_per)).round()
        valuation_fin2_period = (@dmer2_price * valuation_fin2_period_len) - already_done2.sum(:valuation_settlement) + dmer_slmt_done_period.sum(:valuation_settlement)
      end 
      # 実売終着2（過去）
      valuation_fin2_prev = 
        (@dmer2_price * (result_tgt_prev2.length.to_f * (@dmer2_prev_month_per - @dmer2_prev_dec_per)).round()) +
        dmer_slmt_done_prev.sum(:valuation_settlement)
        valuation_fin2 = valuation_fin2_period + valuation_fin2_prev
        if (Date.today > @dmer2_closing_date) || (valuation_current2_price > valuation_fin2)
          valuation_fin2 = valuation_current2_price
        end 
      # 実売終着3（期内）
      if shift_digestion == 0 || shift_schedule == 0
        valuation_fin3_period_len = 0
        valuation_fin3_period = 0
      else  
        valuation_fin3_period_len = ((@dmers_len - dmer_slmt2nd_done_period.length).to_f / shift_digestion * shift_schedule * (@dmer3_this_month_per - @dmer3_dec_per)).round()
        valuation_fin3_period = (@dmer3_price * valuation_fin3_period_len) - already_done3.sum(:valuation_settlement) + dmer_slmt2nd_done_period.sum(:valuation_settlement)
      end  
      # 実売終着3（過去）
      # 26~次の月の月末までに成果になっている案件
      slmt2nd26_next_month_end_of_month_done = 
        dmer_slmt_tgt_prev.where(settlement_second: ..@dmer3_end_date)
        .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
        .where(status_settlement: "完了")
      valuation_fin3_len = (
        (dmer_slmt_tgt_prev.length - slmt2nd26_next_month_end_of_month_done.length - dmer_slmt_dead_len).to_f * 
        @dmer3_prev_month_per
      ).round()
      valuation_fin3_prev = 
        (@dmer3_price * valuation_fin3_len) + dmer_slmt2nd_done_prev.sum(:valuation_second_settlement)
        valuation_fin3 = valuation_fin3_period + valuation_fin3_prev
        if (Date.today > @dmer3_closing_date) || (valuation_current3_price > valuation_fin3)
          valuation_fin3 = valuation_current3_price
        end 
  # 合計
    profit_current = profit_current1_price + profit_current2_price + profit_current3_price
    valuation_current = valuation_current1_price + valuation_current2_price + valuation_current3_price
    if r.user.position == "退職"
      user_base = r.user.position
    elsif r.user.base_sub == "キャッシュレス"
      user_base = r.user.base
    else  
      user_base = r.user.base_sub
    end 
  # dメルの売上の中身
  
    dmer_progress_params = {
      user_id: user_id                                   ,
      base: user_base                                    ,
      date: @month                                       ,
      shift_schedule: shift_schedule                     ,
      shift_digestion: shift_digestion                   ,
      shift_schedule_slmt: shift_schedule_slmt           ,
      shift_digestion_slmt: shift_digestion_slmt         ,
      get_len: @dmers_user_period.length                 ,
      done_len: dmer_done.length                         ,
      slmt_dead_len: dmer_slmt_dead_len                  ,
      def_len: @dmers_user_def.length                    ,
      fin_len: @dmers_fin_len                            ,
      valuation_current: valuation_current               ,
      valuation_current1: valuation_current1_price       ,
      valuation_current2: valuation_current2_price       ,
      valuation_current3: valuation_current3_price       ,
      valuation_fin1: valuation_fin1                     ,
      valuation_fin2: valuation_fin2                     ,
      valuation_fin3: valuation_fin3                     ,
      valuation_fin1_prev: valuation_fin1_prev           ,
      valuation_fin2_prev: valuation_fin2_prev           ,
      valuation_fin3_prev: valuation_fin3_prev           ,
      profit_current: profit_current                     ,
      profit_current1: profit_current1_price                     ,
      profit_current2: profit_current2_price                     ,
      profit_current3: profit_current3_price                     ,
      profit_fin1: profit_fin1                           ,
      profit_fin2: profit_fin2                           ,
      profit_fin3: profit_fin3                           ,
      profit_fin1_prev: profit_fin1_prev                 ,
      profit_fin2_prev: profit_fin2_prev                 ,
      profit_fin3_prev: profit_fin3_prev                 ,
      result1_len: dmer_result1.length                   ,
      result2_len: dmer_slmt_done.length                 ,
      result3_len: dmer_slmt2nd_done.length              ,
      result1_fin_len: result1_fin_len                   ,
      result2_fin_len: result2_fin_len                   ,
      result3_fin_len: result3_fin_len                   ,
      slmt_tgt_prev: dmer_slmt_tgt_prev_len              ,
      done_len_prev: dmer_done_prev.length               ,
      result1_len_prev: dmer_result1_prev.length         ,
      result2_len_prev: dmer_slmt_done_prev.length       ,
      result3_len_prev: dmer_slmt2nd_done_prev.length    ,
      create_date: Date.today
    }
  # 日付とユーザー名が一致しているデータの場合更新、新しいデータの場合保存
    if @dmer_progress_data.present?
      @dmer_progress_data.update(
        dmer_progress_params
      )
    else  
      @dmer_date_progress = DmerDateProgress.new(
        dmer_progress_params
      )
      @dmer_date_progress.save
    end
    cnt += 1    
  end 
  redirect_to calc_periods_path(month: @month) ,alert: "#{cnt}件dメル売上結果を作成しました"
 end 

 def date_destroy
  @date_progress = DmerDateProgress.where(date: params[:month]).where(create_date: params[:create_d])
  @date_progress.destroy_all
  redirect_to dmer_date_progresses_path(month: params[:month]), alert: "#{params[:create_d]}に作成した進捗を削除しました。"
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
