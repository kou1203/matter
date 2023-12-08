class DmerSenbaiDateProgressesController < ApplicationController
  include CommonCalc
  include DmerSenbaiCalc
  include DmerSenbaiValuationCalc

  def index 
    calc_profit
    dmer_senbai_calc_profit
    @create_date = params[:create_d]
    @date_group = DmerSenbaiDateProgress.pluck(:date).uniq
    @create_group = DmerSenbaiDateProgress.pluck(:create_date).uniq
    @users = User.all
    if params[:date].present?
      @month = params[:date].to_date
    elsif params[:search_date].present?
      @month = params[:search_date].to_date
    elsif DmerSenbaiDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date).present?
      @month = DmerSenbaiDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date)
    else
      @month = params[:month].to_date
    end 
    @current_progress = 
    DmerSenbaiDateProgress.includes(:user).where(date: @month)
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
    @current_data_other = @current_progress.where(base: "その他")
    @current_data_retire = @current_progress.where(base: "退職")
    @current_arry = [
      @current_data_chubu,@current_data_kansai, @current_data_kanto, @current_data_kyushu,
      @current_data_partner,@current_data_other, @current_data_retire
    ]

    if @current_progress.present?
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
            data: DmerSenbaiDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
          }
          @data_current << {
            name: "#{base}現状売上", data: DmerSenbaiDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
          }
        else  
          @data_fin << {
            name: "#{base}終着", 
            data: DmerSenbaiDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
          }
          @data_current << {
            name: "#{base}現状売上", data: DmerSenbaiDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
          }
        end
      end
    else
      @data = DmerSenbaiDateProgress.none
    end

    # 比較対象
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
      @comparison = 
        DmerSenbaiDateProgress.where(date: @comparison_date)
      @comparison =
        @comparison.where(create_date: @comparison.maximum(:create_date))
    else  
      if @current_progress.present?
        @comparison = 
          DmerSenbaiDateProgress.where(date: @current_progress.first.date.prev_month)
        @comparison = 
          @comparison.where(create_date: @comparison.maximum(:create_date))
      else  
        @comparison = DmerSenbaiDateProgress.none
      end 
    end 
    # 拠点別現状売上
    @comparison_data_chubu = @comparison.where(base: "中部SS")
    @comparison_data_kansai = @comparison.where(base: "関西SS")
    @comparison_data_kanto = @comparison.where(base: "関東SS")
    @comparison_data_kyushu = @comparison.where(base: "九州SS")
    @comparison_data_partner = @comparison.where(base: "2次店")
    @comparison_data_other = @comparison.where(base: "その他")
    @comparison_data_retire = @comparison.where(base: "退職")
    @comparison_arry = [
      @comparison_data_chubu,@comparison_data_kansai, @comparison_data_kanto, @comparison_data_kyushu,
      @comparison_data_partner,@comparison_data_other, @comparison_data_retire
    ]
  end 

  def progress_create
    # 作成する日付が次の月の場合、指定した月の月末のデータを作成する
    @month = params[:month].to_date
    if Date.today > @month
      @month = @month.end_of_month
    elsif Date.today < @month
      @month = month.beginning_of_month
    else 
      @month = Date.today
    end 
    # 専売人員の情報
    senbai_users = DmerSenbaiUser.group(:user_id).where(date: @month.ago(4.month).beginning_of_month..@month.end_of_month)
    # シフト
    cnt = 0
    # ループする人員（過去4ヶ月以内に獲得があるユーザー）
    # product_user_group = DmerSenbai.group(:user_id)
    #人事の日々の現状売上と終着を作成
    senbai_users.each do |product|
      user_id = product.user_id
      dmer_senbai_data(user_id)
      results = Result.where(date: @start_date..@end_date).where(shift: "キャッシュレス新規")
      results_slmt = Result.where(date: @start_date..@end_date).where(shift: "キャッシュレス決済")
      shifts = Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
      shifts_slmt = Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス決済")

      @dmer_senbai_progress_data = DmerSenbaiDateProgress.find_by(user_id: user_id,date: @month,create_date: Date.today)
      
      result_dmer_sum = Result.includes(:result_cash).where(date: @start_date..@end_date).where(user_id: user_id).sum(:dmer)
      senbai_user = senbai_users.find_by(user_id: user_id)
      dmer_senbai_progress_data = DmerSenbaiDateProgress.find_by(user_id: user_id,date: @month,create_date: Date.today)
      #シフト
      shift_schedule = shifts.where(user_id: user_id).length
      shift_digestion = results.where(user_id: user_id).length
      shift_schedule_slmt = shifts_slmt.where(user_id: user_id).length
      shift_digestion_slmt = results_slmt.where(user_id: user_id).length
      # 獲得終着_獲得数から消化シフトを割って、予定シフトをかける
      dmer_def_len = @dmer_senbais_def.where(date: @start_date..@end_date).length
      dmer_senbais_fin_len = 
        ((result_dmer_sum - dmer_def_len).to_f / shift_digestion * shift_schedule).round() rescue 0
      # 評価売-----------------------------------------------
        #成果1-----------------------------------------------
        # 成果1（審査完了）の現状売
        valuation_current1 = @dmer_senbai_result1.sum(:valuation_new)
        # 成果1終着
        dmer_done_period = @dmer_senbai_result1.where(date: @start_date..@end_date)
        if shift_digestion == 0 || shift_schedule == 0
          valuation_fin1_period_len = 0
          valuation_fin1_period = 0
          valuation_fin1 = 0
        else  
          valuation_fin1_period_len = ((result_dmer_sum - dmer_def_len - dmer_done_period.length).to_f / shift_digestion * shift_schedule * @dmer_senbai1_calc_data.this_month_per).round()
          valuation_fin1 = 
            (@dmer_senbai1_calc_data.price * valuation_fin1_period_len) + 
            (@dmer_senbai1_calc_data.price * (dmer_done_period.length.to_f * @dmer_senbai1_calc_data.this_month_per).round()) + 
            dmer_done.where(date: ...@start_date).where(result_point: start_date(@dmer_senbai1_calc_data)..end_date(@dmer_senbai1_calc_data)).sum(:valuation_new) rescue 0
        end
        # 日付が締め日を超えた時終着と現状売上を切り替える
        if (Date.today > closing_date(@dmer_senbai1_calc_data)) || valuation_current1 >= valuation_fin1
          valuation_fin1 = valuation_current1
        end 
        #成果1-----------------------------------------------
        #成果2-----------------------------------------------
          valuation_current2 = @dmer_senbai_result2.sum(:valuation_settlement)
        # 成果2終着
        # 成果2終着2（期内）
        if shift_digestion == 0 || shift_schedule == 0
          valuation_fin2_period_len = 0
          valuation_fin2_period = 0
        else  
          dmer_slmt_done_period = @dmer_senbai_result2.where(date: @start_date..@end_date)
          valuation_fin2_period_len = 
            ((result_dmer_sum - dmer_def_len - dmer_slmt_done_period.length).to_f / shift_digestion * shift_schedule * @dmer_senbai2_calc_data.this_month_per).round()
          valuation_fin2_period = 
            (@dmer_senbai2_calc_data.price * valuation_fin2_period_len) + 
            @dmer_senbai2_calc_data.price * (dmer_slmt_done_period.length.to_f * @dmer_senbai2_calc_data.this_month_per).round() rescue 0
        end
        # 過去月の決済対象
        dmer_slmt_tgt_prev = 
        @dmer_senbai_done.where(settlement_deadline: @start_date..)
        .where(date: ...@start_date).where(settlement: nil)
        .where(picture_check_date: nil).where.not(status_settlement: "期限切れ")
        .or(
          @dmer_senbai_done.where(settlement_deadline: @start_date.. )
          .where(date: ...@start_date)
          .where(settlement: start_date(@dmer_senbai1_calc_data)..end_date(@dmer_senbai1_calc_data))
          .where(picture_check_date: nil).where.not(status_settlement: "期限切れ")
        )
        valuation_fin2_prev = 
          (@dmer_senbai2_calc_data.price * (dmer_slmt_tgt_prev.length.to_f * @dmer_senbai2_calc_data.prev_month_per).round()) +
          valuation_current2_data.where(date: ...@start_date).sum(:valuation_settlement) rescue 0
        # 日付が締め日を超えた時終着と現状売上を切り替える
        if (Date.today > closing_date(@dmer_senbai2_calc_data)) || (valuation_current2 >= (valuation_fin2_period + valuation_fin2_prev))
          valuation_fin2 = valuation_current2
        else  
          valuation_fin2 = valuation_fin2_period + valuation_fin2_prev
        end 
        #成果2-----------------------------------------------
        #成果3-----------------------------------------------
        valuation_current3 = @dmer_senbai_done_slmter2nd.sum(:valuation_second_settlement)
        # 成果3終着（期間内）
        if shift_digestion == 0 || shift_schedule == 0
          valuation_fin3_period_len = 0
          valuation_fin3_period = 0
        else  
          valuation_current3_period = @dmer_senbai_done_slmter2nd.where(date: @start_date..@end_date)
          valuation_fin3_period_len = ((result_dmer_sum - dmer_def_len - valuation_current3_period.length).to_f / shift_digestion * shift_schedule * @dmer_senbai3_calc_data.this_month_per).round()
          valuation_fin3_period = (@dmer_senbai3_calc_data.price * valuation_fin3_period_len) + (@dmer_senbai3_calc_data.price * (valuation_current3_period.length.to_f * @dmer_senbai3_calc_data.this_month_per).round()) rescue 0
        end 
        valuation_fin3_prev = 
        (@dmer_senbai3_calc_data.price * (dmer_slmt_tgt_prev.length.to_f * @dmer_senbai3_calc_data.prev_month_per).round()) + 
        @dmer_senbai_done_slmter2nd.where(date: ...@start_date).sum(:valuation_second_settlement) rescue 0
        if (Date.today > closing_date(@dmer_senbai3_calc_data)) || (valuation_current3 >= (valuation_fin3_period + valuation_fin3_prev))
          valuation_fin3 = valuation_current3
        else  
          valuation_fin3 = valuation_fin3_period + valuation_fin3_prev
        end 

        valuation_current = valuation_current1 + valuation_current2 + valuation_current3
        valuation_fin = valuation_fin1 + valuation_fin2 + valuation_fin3
          
      # 評価売-----------------------------------------------
      # 実売-----------------------------------------------  
      # 計算期間からd専売の情報を取得（終着単価と集計期間を取得するため）
      @calc_periods_profit = CalcPeriod.where(sales_category: "実売")
      d_calc_data = @calc_periods_profit.where("name LIKE ?","%dメル専売%").where("name LIKE ?","%#{senbai_user.client}%").first
      # 現状売上
      # 成果になったデータ
      dmer_senbais_slmter_ok = 
        @dmer_senbais_slmter.where(industry_status: "OK")
          .where(app_check: "OK").where.not(dup_check: "重複")
          .where(partner_status: "Active").where(status: "審査OK")
          .where(status_settlement: "完了").where(picture_check: "合格")
      # 現状売上
      # 当月成果になったデータ
      profit_current_data = 
        dmer_senbais_slmter_ok
        .where(picture_check_date: start_date(d_calc_data)..end_date(d_calc_data))
      # ★現状売上
      profit_current = profit_current_data.sum(:profit) rescue 0
      
      # ◆当月終着
      # 当月獲得した案件が当月成果になったデータ
      profit_current_data_period = profit_current_data.where(date: @start_date..@end_date)
      # ①.これから成果になる件数を出す。
      profit_fin_period_len = 
        (
          (@dmer_senbais_period - profit_current_data_period.length).to_f / 
          shift_digestion * shift_schedule * d_calc_data.this_month_per
        ).round() rescue 0
      # ②成果になる売上
      profit_fin_period = d_calc_data.price * profit_fin_period_len rescue 0
      # ◆前月以前の終着
      # ③前月以前の決済母体を出す
      slmt_target_prev = 
        @dmer_senbai_done.where(date: ...@start_date)
        .where.not(status_settlement: "期限切れ")
        .where(picture_check_date: nil).or(
          @dmer_senbai_done.where(date: ...@start_date)
          .where.not(status_settlement: "期限切れ")
          .where(picture_check_date: start_date(d_calc_data)..end_date(d_calc_data))
        )
      # 前月以前獲得した案件が当月成果になったデータ
      profit_current_data_prev = profit_current_data.where(date: ...@start_date)
      # ④前月以前の案件でこれから成果になる件数を出す
      profit_fin_prev_len = (
        (slmt_target_prev - profit_current_data_prev.length).to_f * d_calc_data.prev_month_per
      ).round() rescue 0
      # ⑤成果になる売上
      profit_fin_prev_len = d_calc_data.price * profit_fin_prev_len_len rescue 0
      # ◆終着(合計：② + ⑤ + 現状売上）
      profit_fin = profit_fin_period + profit_fin_prev_len + profit_current
      # 現状売上と終着売上を同じにする。
      if Date.today >= closing_date(d_calc_data)
        profit_fin = profit_current
      end 

      # 実売-----------------------------------------------
      # 退職者の場合はpositionを退職に変更、キャッシュ商材であったら拠点名、違う商材の場合は別途変更させる。
      if product.user.position == "退職"
        user_base = product.user.position
      elsif product.user.base_sub == "キャッシュレス"
        user_base = product.user.base
      else 
        user_base = "その他"
      end 

      dmer_senbai_progress_params = {
        user_id: user_id                                   ,
        base: user_base                                    ,
        date: @month                                        ,
        shift_schedule: shift_schedule                     ,
        shift_schedule_slmt: shift_schedule_slmt           ,
        shift_digestion: shift_digestion                   ,
        shift_digestion_slmt: shift_digestion_slmt         ,
        get_len: result_dmer_sum                           ,
        def_len: dmer_def_len              ,
        fin_len: dmer_senbais_fin_len                      ,
        valuation_current:  valuation_current             ,
        valuation_current1: valuation_current1             ,
        valuation_current2: valuation_current2             ,
        valuation_current3: valuation_current3             ,
        valuation_fin:  valuation_fin                      ,
        valuation_fin1: valuation_fin1                     ,
        valuation_fin2: valuation_fin2                     ,
        valuation_fin3: valuation_fin3                     ,
        profit_current: profit_current                     ,
        profit_fin: profit_fin                             ,
        create_date: Date.today
      }
      # 日付とユーザー名が一致しているデータの場合更新、新しいデータの場合保存
      if @dmer_senbai_progress_data.present?
        @dmer_senbai_progress_data.update(
          dmer_senbai_progress_params
        )
      else  
        @dmer_senbai_progress_data = DmerSenbaiDateProgress.new(
          dmer_senbai_progress_params
        )
        @dmer_senbai_progress_data.save
      end
      cnt += 1
    end # product_user_groupのループ文
    redirect_to calc_periods_path(month: @month) ,alert: "#{cnt}件dメル専売の売上結果を作成しました"
  end # def create
end
