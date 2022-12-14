class DmerDateProgressesController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @date_group = DmerDateProgress.pluck(:date).uniq
    @create_group = DmerDateProgress.pluck(:create_date).uniq
    if params[:date].present?
      @month = params[:date].to_date
      @dmer_date_progresses_month = DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
      @current_progress = 
        @dmer_date_progresses_month.where(date: params[:date].to_date)
        .where(create_date: @dmer_date_progresses_month.maximum(:create_date))
    else
      if params[:search_date].present?
        @month = params[:search_date].to_date
      end 
      @dmer_date_progresses_month = DmerDateProgress.where(date: @month.beginning_of_month..@month.end_of_month)
      @current_progress = 
        @dmer_date_progresses_month.where(date: @dmer_date_progresses_month.maximum(:date))
        .where(create_date: @dmer_date_progresses_month.maximum(:create_date))
    end 
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
      @dmer_comparison = 
        DmerDateProgress.where(date: @comparison_date)
      @dmer_comparison =
        @dmer_comparison.where(create_date: @dmer_comparison.maximum(:create_date))
    else  
      if @current_progress.present?
        @dmer_comparison = 
          DmerDateProgress.where(date: @current_progress.first.date.prev_month..@current_progress.first.date.prev_month)
          .where(create_date: @dmer_date_progresses_month.maximum(:create_date))
      else  
        @dmer_comparison = DmerDateProgress.none
      end 
    end 
  end 

 def progress_create
  @month = params[:month].to_date
  if Date.today > @month
    @month = @month.end_of_month
  else 
    @month = Date.today
  end 
  @calc_periods = CalcPeriod.where(sales_category: "実売")
  calc_period_and_per
  @results = Result.where(date: @start_date..@end_date).where(shift: "キャッシュレス新規")
  @shifts = Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
  cnt = 0
  @results.group(:user_id).each do |r|
    @calc_periods = CalcPeriod.where(sales_category: "実売")
    calc_period_and_per
    user_id = r.user_id
    @dmer_progress_data = DmerDateProgress.find_by(user_id: user_id,date: @month,create_date: Date.today)
    shift_schedule = @shifts.where(user_id: user_id).length
    shift_digestion = @results.where(user_id: user_id).length
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
    dmer_wait_prev = dmer_wait.where(date: ...@start_date)
    # 審査完了
    dmer_done = 
      @dmers_user.where(result_point: @dmer1_start_date..@dmer1_end_date)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
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
    .where(status: "審査OK")
    .where.not(industry_status: "NG")
    .where.not(industry_status: "×")
    .where.not(industry_status: "要確認")
    .or(
      @dmers_slmter.where(settlement: @dmer1_start_date..@dmer1_end_date)
      .where(result_point: ..@dmer1_end_date)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
    )
    dmer_result1_prev = dmer_result1.where(date: ...@start_date)
  # 成果2
    dmer_slmt_done = 
      @dmers_slmter.where(status_update_settlement: @dmer2_start_date..@dmer2_end_date)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      .where(status_settlement: "完了")
      dmer_slmt_done_prev = dmer_slmt_done.where(date: ...@start_date)
  # 成果3
    dmer_slmt2nd_done = 
      @dmers_slmter.where(settlement_second: @dmer3_start_date..@dmer3_end_date)
      .where("? >= status_update_settlement", @dmer3_end_date)
      .where(status: "審査OK")
      .where.not(industry_status: "NG")
      .where.not(industry_status: "×")
      .where.not(industry_status: "要確認")
      .where(status_settlement: "完了")
      .or(
        @dmers_slmter
        .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
        .where("? >= settlement_second", @dmer3_end_date)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
      )
      dmer_slmt2nd_done_prev = dmer_slmt2nd_done.where(date: ...@start_date)
      # 実売
      profit_current1_price = dmer_result1.sum(:profit_new)
      profit_current2_price = dmer_slmt_done.sum(:profit_settlement)
      profit_current3_price = dmer_slmt2nd_done.sum(:profit_second_settlement)
      # 26~25までの獲得で前月中に成果に至っているデータ
      already_done1 = 
        @dmers_user_period.where(result_point: ...@dmer1_start_date)
        .where(settlement: ...@dmer1_start_date)
        .where(status: "審査OK")
        .where.not(industry_status: "NG")
        .where.not(industry_status: "×")
        .where.not(industry_status: "要確認")
        .where(status_settlement: "完了")
      already_done2 = already_done1.where(status_update_settlement: ...@dmer2_start_date)
      already_done3 = already_done2.where(settlement_second: ...@dmer3_start_date)
      # 過去月の成果対象母体
      result_tgt_prev1 = dmer_slmt_tgt_prev.where(settlement: nil)
      result_tgt_prev2 = dmer_slmt_tgt_prev.where(status_update_settlement: nil)
      
      # 実売終着1（期内）
      profit_fin1_period_len = (@dmers_len / shift_digestion * shift_schedule * @dmer1_this_month_per).round()
      profit_fin1_period = (@dmer1_price * profit_fin1_period_len) - already_done1.sum(:profit_new)
      # 実売終着1（過去）
      profit_fin1_prev = 
        (@dmer1_price * ( result_tgt_prev1.length * @dmer1_prev_month_per).round()) +
        dmer_result1_prev.sum(:profit_new)
        profit_fin1 = profit_fin1_period + profit_fin1_prev
        if (Date.today > @closing_date) || (profit_current1_price > profit_fin1)
          profit_fin1 = profit_current1_price
        end 
      # 実売終着2（期内）
      profit_fin2_period_len = (@dmers_len / shift_digestion * shift_schedule * @dmer2_this_month_per).round()
      profit_fin2_period = (@dmer2_price * profit_fin2_period_len) - already_done2.sum(:profit_settlement)
      # 実売終着2（過去）
      profit_fin2_prev = 
        (@dmer2_price * (result_tgt_prev2.length * @dmer2_prev_month_per).round()) +
        dmer_slmt_done_prev.sum(:profit_settlement)
        profit_fin2 = profit_fin2_period + profit_fin2_prev
        if (Date.today > @closing_date) || (profit_current2_price > profit_fin2)
          profit_fin2 = profit_current2_price
        end 
      # 実売終着3（期内）
      profit_fin3_period_len = (@dmers_len / shift_digestion * shift_schedule * @dmer3_this_month_per).round()
      profit_fin3_period = (@dmer3_price * profit_fin3_period_len) - already_done3.sum(:profit_settlement)
      # 実売終着3（過去）
      # 26~次の月の月末までに成果になっている案件
      slmt2nd26_next_month_end_of_month_done = 
        dmer_slmt_tgt_prev.where(settlement_second: ..@dmer3_end_date)
        .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
        .where(status_settlement: "完了")
      profit_fin3_len = (
        (dmer_slmt_tgt_prev.length - slmt2nd26_next_month_end_of_month_done.length - dmer_slmt_dead_len) * 
        @dmer3_prev_month_per
      ).round()
      profit_fin3_prev = 
        (@dmer3_price * profit_fin3_len) + dmer_slmt2nd_done_prev.sum(:profit_second_settlement)
        profit_fin3 = profit_fin3_period + profit_fin3_prev
        if (Date.today > @closing_date) || (profit_current3_price > profit_fin3)
          profit_fin3 = profit_current3_price
        end 

      # 評価売
      @calc_periods = CalcPeriod.where(sales_category: "評価売")
      calc_period_and_per
      valuation_current1_price = dmer_done.sum(:valuation_new)
      valuation_current2_price = dmer_slmt_done.sum(:valuation_settlement)
      valuation_current3_price = dmer_slmt2nd_done.sum(:valuation_second_settlement)
      # 実売終着1（期内）
      valuation_fin1_period_len = (@dmers_len / shift_digestion * shift_schedule * @dmer1_this_month_per).round()
      valuation_fin1_period = (@dmer1_price * valuation_fin1_period_len) - already_done1.sum(:valuation_new)
      # 実売終着1（過去）
      valuation_fin1_prev = 
        (@dmer1_price * (dmer_wait_prev.length * @dmer1_prev_month_per).round()) +
        dmer_result1_prev.sum(:valuation_new)
        valuation_fin1 = valuation_fin1_period + valuation_fin1_prev
        if (Date.today > @closing_date) || (valuation_current1_price > valuation_fin1)
          valuation_fin1 = valuation_current1_price
        end 
      # 実売終着2（期内）
      valuation_fin2_period_len = (@dmers_len / shift_digestion * shift_schedule * @dmer2_this_month_per).round()
      valuation_fin2_period = (@dmer2_price * valuation_fin2_period_len) - already_done2.sum(:valuation_settlement)
      # 実売終着2（過去）
      valuation_fin2_prev = 
        (@dmer2_price * (result_tgt_prev2.length * @dmer2_prev_month_per).round()) +
        dmer_slmt_done_prev.sum(:valuation_settlement)
        valuation_fin2 = valuation_fin2_period + valuation_fin2_prev
        if (Date.today > @closing_date) || (valuation_current2_price > valuation_fin2)
          valuation_fin2 = valuation_current2_price
        end 
      # 実売終着3（期内）
      valuation_fin3_period_len = (@dmers_len / shift_digestion * shift_schedule * @dmer3_this_month_per).round()
      valuation_fin3_period = (@dmer3_price * valuation_fin3_period_len) - already_done3.sum(:valuation_settlement)
      # 実売終着3（過去）
      # 26~次の月の月末までに成果になっている案件
      slmt2nd26_next_month_end_of_month_done = 
        dmer_slmt_tgt_prev.where(settlement_second: ..@dmer3_end_date)
        .where(status_update_settlement: @dmer3_start_date..@dmer3_end_date)
        .where(status_settlement: "完了")
      valuation_fin3_len = (
        (dmer_slmt_tgt_prev.length - slmt2nd26_next_month_end_of_month_done.length - dmer_slmt_dead_len) * 
        @dmer3_prev_month_per
      ).round()
      valuation_fin3_prev = 
        (@dmer3_price * valuation_fin3_len) + dmer_slmt2nd_done_prev.sum(:valuation_second_settlement)
        valuation_fin3 = valuation_fin3_period + valuation_fin3_prev
        if (Date.today > @closing_date) || (valuation_current3_price > valuation_fin3)
          valuation_fin3 = valuation_current3_price
        end 
  # 合計
    profit_current = profit_current1_price + profit_current2_price + profit_current3_price
    valuation_current = valuation_current1_price + valuation_current2_price + valuation_current3_price
  # dメルの売上の中身
    dmer_progress_params = {
      user_id: user_id                                   ,
      base: r.user.base                                  ,
      date: @month                                       ,
      shift_schedule: shift_schedule                     ,
      shift_digestion: shift_digestion                   ,
      get_len: @dmers_user_period.length                 ,
      wait_len: dmer_wait.length                         ,
      done_len: dmer_done.length                         ,
      slmt_dead_len: dmer_slmt_dead_len                  ,
      def_len: @dmers_user_def.length                    ,
      fin_len: @dmers_fin_len                            ,
      valuation_current: valuation_current               ,
      valuation_fin1: valuation_fin1                     ,
      valuation_fin2: valuation_fin2                     ,
      valuation_fin3: valuation_fin3                     ,
      valuation_fin1_prev: valuation_fin1_prev           ,
      valuation_fin2_prev: valuation_fin2_prev           ,
      valuation_fin3_prev: valuation_fin3_prev           ,
      profit_current: profit_current                     ,
      profit_fin1: profit_fin1                           ,
      profit_fin2: profit_fin2                           ,
      profit_fin3: profit_fin3                           ,
      profit_fin1_prev: profit_fin1_prev                 ,
      profit_fin2_prev: profit_fin2_prev                 ,
      profit_fin3_prev: profit_fin3_prev                 ,
      result1_len: dmer_result1.length                   ,
      result2_len: dmer_slmt_done.length                 ,
      result3_len: dmer_slmt2nd_done.length              ,
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

  private

  def dmer_progress_param 
    params.require(:dmer_date_progress).permit(
      :user                        ,
      :base                        ,
      :date                        ,
      :shift_schedule              ,
      :shift_digestion             ,
      :get_len                     ,
      :def_len                     ,
      :fin_len                     ,
      :valuation_current           ,
      :valuation_fin               ,
      :profit_current              ,
      :profit_fin                  ,
      # 各種獲得数
      :wait_len                    ,
      :done_len                    ,
      :slmt_dead_len               ,
      :result1_len                 ,
      :result2_len                 ,
      :result3_len                 ,
      # 各種獲得数（過去月）
      :slmt_tgt_prev               ,
      :done_len_prev               ,
      :result1_len_prev            ,
      :result2_len_prev            ,
      :result3_len_prev            ,
      :create_date
    )
  end 

end
