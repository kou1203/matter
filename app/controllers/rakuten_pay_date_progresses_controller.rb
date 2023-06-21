class RakutenPayDateProgressesController < ApplicationController

  def index 
    @profit_price = CalcPeriod.where(sales_category: "実売").find_by(name: "楽天ペイ成果1").price
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @create_date = params[:create_d]
    @date_group = RakutenPayDateProgress.pluck(:date).uniq
    @create_group = RakutenPayDateProgress.pluck(:create_date).uniq
    @users = User.all
    if params[:date].present?
      @month = params[:date].to_date
    elsif params[:search_date].present?
      @month = params[:search_date].to_date  
    elsif RakutenPayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date).present? 
      @month = RakutenPayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date)
    else
      @month = params[:month].to_date
    end 

    @current_progress = 
    RakutenPayDateProgress.includes(:user).where(date: @month)
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
            data: RakutenPayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
          }
          @data_current << {
            name: "#{base}現状売上", data: RakutenPayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
          }
        else  
          @data_fin << {
            name: "#{base}終着", 
            data: RakutenPayDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
          }
          @data_current << {
            name: "#{base}現状売上", data: RakutenPayDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
          }
        end 
      end
    else
      @data = RakutenPayDateProgress.none
    end

    # 比較対象
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
      @comparison = 
        RakutenPayDateProgress.where(date: @comparison_date)
      @comparison =
        @comparison.where(create_date: @comparison.maximum(:create_date))
    else  
      if @current_progress.present?
        @comparison = 
          RakutenPayDateProgress.where(date: @current_progress.first.date.prev_month)
        @comparison = 
          @comparison.where(create_date: @comparison.maximum(:create_date))
      else  
        @comparison = RakutenPayDateProgress.none
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
    @calc_periods = CalcPeriod.where(sales_category: "実売")
    calc_period_and_per
    @results = Result.where(date: @start_date..@end_date).where(shift: "キャッシュレス新規")
    @shifts = Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
    cnt = 0
    @rakuten_pays_group = Shift.group(:user_id)
    @rakuten_pays_group.group(:user_id).each do |r|
      @calc_periods = CalcPeriod.where(sales_category: "実売")
      calc_period_and_per
      user_id = r.user_id
      @rakuten_pay_progress_data = RakutenPayDateProgress.find_by(user_id: user_id,date: @month,create_date: Date.today)
      shift_schedule = @shifts.where(user_id: user_id).length
      shift_digestion = @results.where(user_id: user_id).length
      # 獲得内訳
      @rakuten_pays_user = RakutenPay.includes(:store_prop).where(user_id: user_id)
      @rakuten_pays_user_period = @rakuten_pays_user.where(date: @start_date..@end_date)
      @rakuten_pays_user_share = @rakuten_pays_user.where(share: @start_date..@end_date)
      @rakuten_pays_fin_len = (@rakuten_pays_user_period.length.to_f / shift_digestion * shift_schedule).round() rescue 0

      # 審査完了（前月16日〜15日）
      rakuten_pay_done = 
        @rakuten_pays_user.where(result_point: @rakuten_pay1_start_date..@rakuten_pay1_end_date)
        .where(status: "OK")
        .where.not(payment_flag: "NG")
    # 現状売上
      valuation_current = 0
      profit_current = 0
    # 実売
      profit_current = rakuten_pay_done.sum(:profit)
      rakuten_pay_result_len = rakuten_pay_done.length 
      prev_price_result = rakuten_pay_done.where(profit: 13500).length
    # 終着（個人当月）
      rakuten_pay_person_this_month = @rakuten_pays_user.where(date: @start_date..@end_date).where(store_prop: {race: "個人"})
      rakuten_pay_person_this_month_len_fin = (rakuten_pay_person_this_month.length.to_f / shift_digestion * shift_schedule * @rakuten_pay1_this_month_per).round() rescue 0
      rakuten_pay_person_this_month_profit_fin = @rakuten_pay_price * rakuten_pay_person_this_month_len_fin
    # 終着（個人過去月）
    # 過去の案件で今月成果になった件数
    rakuten_pay_person_done_prev = rakuten_pay_done.where(date: ...@start_date).where(store_prop: {race: "個人"})
    rakuten_pay_person_prev = @rakuten_pays_user.where(date: ...@start_date).where(store_prop: {race: "個人"})
    rakuten_pay_person_prev = 
      rakuten_pay_person_prev.where(status: "審査待ち")
      .or(
        rakuten_pay_person_prev.where(status: "審査中")
      )
    rakuten_pay_person_prev_len = (rakuten_pay_person_prev.length.to_f * @rakuten_pay1_prev_month_per).round()
    rakuten_pay_person_prev_profit_fin = (@rakuten_pay_price * rakuten_pay_person_prev_len) + (@rakuten_pay_price * rakuten_pay_person_done_prev.length)
    # 終着（個人合計）
    rakuten_pay_person_profit_sum = rakuten_pay_person_this_month_profit_fin + rakuten_pay_person_prev_profit_fin
    # 終着（法人当月）
    rakuten_pay_company_calc = @calc_periods.find_by(name: "楽天ペイ成果1（法人）")
    rakuten_pay_company_this_month = @rakuten_pays_user.where(date: @start_date..@end_date).where(store_prop: {race: "法人"})
    rakuten_pay_company_this_month_len_fin = (rakuten_pay_company_this_month.length.to_f / shift_digestion * shift_schedule * rakuten_pay_company_calc.this_month_per).round() rescue 0
    rakuten_pay_company_this_month_profit_fin = @rakuten_pay_price * rakuten_pay_company_this_month_len_fin
    # 終着（法人過去月）
    rakuten_pay_company_done_prev = rakuten_pay_done.where(date: ...@start_date).where(store_prop: {race: "法人"})
    rakuten_pay_company_prev = @rakuten_pays_user.where(date: ...@start_date).where(store_prop: {race: "法人"})
    rakuten_pay_company_prev = 
      rakuten_pay_company_prev.where(status: "審査待ち")
      .or(
        rakuten_pay_company_prev.where(status: "審査中")
      )
    rakuten_pay_company_prev_len = (rakuten_pay_company_prev.length.to_f * rakuten_pay_company_calc.prev_month_per).round()
    rakuten_pay_company_prev_profit_fin = (@rakuten_pay_price * rakuten_pay_company_prev_len) + (@rakuten_pay_price * rakuten_pay_company_done_prev.length)
    # 終着（法人合計）
    rakuten_pay_company_profit_sum = rakuten_pay_company_this_month_profit_fin + rakuten_pay_company_prev_profit_fin
    result_fin_len = 
      rakuten_pay_person_this_month_len_fin + rakuten_pay_person_prev_len + 
      rakuten_pay_company_this_month_len_fin + rakuten_pay_company_prev_len +
      rakuten_pay_company_done_prev.length + 
      rakuten_pay_person_done_prev.length
    # 終着（個人合計＋法人合計）
    profit_fin = rakuten_pay_person_profit_sum + rakuten_pay_company_profit_sum
    get_len = @rakuten_pays_user.where(date: @start_date..@end_date).length
    fin_len = (get_len.to_f / shift_digestion * shift_schedule).round() rescue 0
    prev_price_result_fin = 0
      if (profit_current > profit_fin) || (Date.today > @rakuten_pay1_closing_date)
        profit_fin = profit_current
        result_fin_len = rakuten_pay_result_len
        prev_price_result_fin = rakuten_pay_done.where(profit: 13500).length
      end
    # profit_fin = rakuten_pay_company_prev_len + (rakuten_pay_company_done_prev.length.to_f * rakuten_pay_company_calc.prev_month_per).round()


      @calc_periods = CalcPeriod.where(sales_category: "評価売")
      calc_period_and_per
      @rakuten_pays_user_period = @rakuten_pays_user.where(date: @rakuten_pay1_start_date..@rakuten_pay1_end_date)
      @rakuten_val_shift_schedule = Shift.where(user_id: user_id).where(start_time: @rakuten_pay1_start_date..@rakuten_pay1_end_date).where(shift: "キャッシュレス新規").length

      @rakuten_val_shift_digestion = Result.where(user_id: user_id).where(date: @rakuten_pay1_start_date..@rakuten_pay1_end_date).where(shift: "キャッシュレス新規").length
      @rakuten_pay_def = 
        @rakuten_pays_user_period.where(status: "自社不備")
        .or(@rakuten_pays_user_period.where(status: "自社NG"))
        .or(
          @rakuten_pays_user_period.where.not(deficiency: nil)
          .where.not(share: @rakuten_pay1_start_date..@rakuten_pay1_end_date)
        )
      @rakuten_pay_inc = 
      @rakuten_pays_user.where.not(date: @rakuten_pay1_start_date..@rakuten_pay1_end_date).where(share: @rakuten_pay1_start_date..@rakuten_pay1_end_date).where.not(deficiency: nil)
      valuation_current = 
        @rakuten_pays_user_period.sum(:valuation) - @rakuten_pay_def.sum(:valuation) + @rakuten_pay_inc.sum(:valuation)
      rakuten_val_len = 
        @rakuten_pays_user_period.length - 
        @rakuten_pay_def.length +
        @rakuten_pay_inc.length
      rakuten_val_len_fin = 
        (rakuten_val_len.to_f / @rakuten_val_shift_digestion * @rakuten_val_shift_schedule * @rakuten_pay1_this_month_per).round() rescue 0
      valuation_fin = @rakuten_pay_price * rakuten_val_len_fin

      if (valuation_current > valuation_fin) || (Date.today > @rakuten_pay1_closing_date)
        valuation_fin = valuation_current
        rakuten_val_len_fin = rakuten_val_len
      end 


      if r.user.position == "退職"
        user_base = r.user.position
      elsif r.user.base_sub == "キャッシュレス"
        user_base = r.user.base
      else  
        user_base = r.user.base_sub
      end 
    # 楽天ペイの売上の中身
      rakuten_pay_progress_params = {
        user_id: user_id                                       ,
        base: user_base                                        ,
        date: @month                                           ,
        shift_schedule: shift_schedule                         ,
        shift_digestion: shift_digestion                       ,
        get_len: get_len                                       ,
        share_len: @rakuten_pays_user_share.length             ,
        fin_len: fin_len                                       ,
        valuation_current: valuation_current                   ,
        valuation_fin: valuation_fin                           ,
        profit_current: profit_current                         ,
        profit_fin: profit_fin                                 ,
        result_len: rakuten_pay_result_len                     ,
        result_fin_len: result_fin_len                         ,
        prev_price_result: prev_price_result                   ,
        prev_price_result_fin: prev_price_result_fin           ,
        create_date: Date.today
      }
    # 日付とユーザー名が一致しているデータの場合更新、新しいデータの場合保存
      if @rakuten_pay_progress_data.present?
        @rakuten_pay_progress_data.update(
          rakuten_pay_progress_params
        )
      else  
        @rakuten_pay_date_progress = RakutenPayDateProgress.new(
          rakuten_pay_progress_params
        )
        @rakuten_pay_date_progress.save
      end
      cnt += 1    
    end 
    redirect_to calc_periods_path(month: @month) ,alert: "#{cnt}件楽天ペイ売上結果を作成しました"

  end   

  def date_destroy
    @date_progress = RakutenPayDateProgress.where(date: params[:month]).where(create_date: params[:create_d])
    @date_progress.destroy_all
    redirect_to rakuten_pay_date_progresses_path(month: params[:month]), alert: "#{params[:create_d]}に作成した進捗を削除しました。"
   end
end
