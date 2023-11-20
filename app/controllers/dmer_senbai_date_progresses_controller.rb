class DmerSenbaiDateProgressesController < ApplicationController
  include CommonCalc
  include DmerSenbaiCalc

  def index 
    calc_profit
    dmer_senbai_calc_profit
    calc_valuation
    dmer_senbai_calc_valuation2
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
    @current_data_femto = @current_progress.where(base: "フェムト")
    @current_data_summit = @current_progress.where(base: "サミット")
    @current_data_retire = @current_progress.where(base: "退職")
    @current_arry = [
      @current_data_chubu,@current_data_kansai, @current_data_kanto, @current_data_kyushu,
      @current_data_partner,@current_data_femto, @current_data_summit, @current_data_retire
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
    @comparison_data_femto = @comparison.where(base: "フェムト")
    @comparison_data_summit = @comparison.where(base: "サミット")
    @comparison_data_retire = @comparison.where(base: "退職")
    @comparison_arry = [
      @comparison_data_chubu,@comparison_data_kansai, @comparison_data_kanto, @comparison_data_kyushu,
      @comparison_data_partner,@comparison_data_femto, @comparison_data_summit, @comparison_data_retire
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
    # 計算する内容を実売に選択

    # シフト
    calc_profit # 計算する期間と成果になる率の関数をモジュールから取得
    results = Result.where(date: @start_date..@end_date).where(shift: "キャッシュレス新規")
    results_slmt = Result.where(date: @start_date..@end_date).where(shift: "キャッシュレス決済")
    shifts = Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
    shifts_slmt = Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス決済")
    # 専売人員の情報
    senbai_users = DmerSenbaiUser.where(date: @start_date..@end_date)
    cnt = 0
    # ループする人員（過去4ヶ月以内に獲得があるユーザー）
    # product_user_group = DmerSenbai.group(:user_id)
    #人事の日々の現状売上と終着を作成
    senbai_users.each do |product|
      user_id = product.user_id
      @dmer_senbai_progress_data = DmerSenbaiDateProgress.find_by(user_id: user_id,date: @month,create_date: Date.today)
      calc_profit # 計算する期間と成果になる率の関数をモジュールから取得
      # 終着から参照するdメルの件数
      result_dmer_sum = Result.includes(:result_cash).where(date: @start_date..@end_date).where(user_id: user_id).sum(:dmer)
      senbai_user = senbai_users.find_by(user_id: user_id)
      dmer_senbai_progress_data = DmerSenbaiDateProgress.find_by(user_id: user_id,date: @month,create_date: Date.today)
      #シフト
      shift_schedule = shifts.where(user_id: user_id).length
      shift_digestion = results.where(user_id: user_id).length
      shift_schedule_slmt = shifts_slmt.where(user_id: user_id).length
      shift_digestion_slmt = results_slmt.where(user_id: user_id).length
      # 獲得内訳-------------------------------------------
      dmer_senbais_user = DmerSenbai.where(user_id: user_id)
      dmer_senbais_slmter = DmerSenbai.where(settlementer_id: user_id)
      dmer_senbais_user_period = dmer_senbais_user.where(date: @start_date..@end_date)
      # 申込取消or不備対応中or審査NGor社内確認中
      dmer_senbais_user_def = 
      dmer_senbais_user_period.where(status: "審査NG")
        .or(dmer_senbais_user_period.where(status: "申込取消"))
        .or(dmer_senbais_user_period.where(status: "不備対応中"))
        .or(dmer_senbais_user_period.where(status: "社内確認中"))
        .or(dmer_senbais_user_period.where(industry_status: "NG"))
        .or(dmer_senbais_user_period.where(app_check: "NG"))
        .or(dmer_senbais_user_period.where(dup_check: "重複"))
        .or(dmer_senbais_user_period.where.not(partner_status: "Active"))
      # 獲得数から消化シフトを割って、予定シフトをかける
      dmer_senbais_fin_len = 
        ((result_dmer_sum - dmer_senbais_user_def.length).to_f / shift_digestion * shift_schedule).round() rescue 0
      # 獲得内訳-------------------------------------------
      # 実売-----------------------------------------------  
        dmer_senbai_calc_profit # 実売を計算する期間, 単価, 成果率を取得
      # 終着（当月が成果になる率、２次成果の%と単価で出すようにする）, 一緒に現状売上の期間も指定する。
      if senbai_user.present? && senbai_user.client == "ドコモ" # dメル成果1の情報参照
        profit_fin = @dmer_senbai_docomo_price * (result_dmer_sum.to_f / shift_digestion * shift_schedule * @dmer_senbai_docomo_this_month_per).round() rescue 0
      elsif senbai_user.present? && senbai_user.client == "メディア" # dメル成果2の情報参照
        profit_fin = @dmer_senbai_media_price * (result_dmer_sum.to_f / shift_digestion * shift_schedule * @dmer_senbai_media_this_month_per).round() rescue 0
      else 
        profit_fin = 0
      end
      # 現状売上 （当月で成果になった売上）
        dmer_senbais_slmter_ok = 
          dmer_senbais_slmter.where(industry_status: "OK")
          .where(app_check: "OK").where.not(dup_check: "重複")
          .where(partner_status: "Active").where(status: "審査OK")
          .where(status_settlement: "完了").where(picture_check: "合格")
      if dmer_senbais_slmter.present?
        profit_current = 
        dmer_senbais_slmter_ok.where(client: "ドコモ").where(picture_check_date: @dmer_senbai_docomo_start_date..@dmer_senbai_docomo_end_date).sum(:profit) +
        dmer_senbais_slmter_ok.where(client: "メディア").where(picture_check_date: @dmer_senbai_media_start_date..@dmer_senbai_media_end_date).sum(:profit)
      else  
        profit_current = 0
      end

      if profit_current >= profit_fin 
        profit_fin = profit_current
      end 

      # 実売-----------------------------------------------
      
      # 評価売-----------------------------------------------
        calc_valuation # 計算する期間と成果になる率の関数をモジュールから取得
        # dメルで審査が通っている案件
        dmer_done = 
          dmer_senbais_user
          .where(industry_status: "OK")
          .where(app_check: "OK")
          .where.not(dup_check: "重複")
          .where(partner_status: "Active")
          .where(status: "審査OK")
        #成果1-----------------------------------------------
        dmer_senbai_calc_valuation1 # 1次成果の期間、単価、成果になる率を取得
        # 成果1（審査完了）の現状売
        valuation_current1 = dmer_done.where(result_point: @dmer_senbai1_start_date..@dmer_senbai1_end_date).sum(:valuation_new)
        # 成果1終着
        dmer_done_period = 
          dmer_done.where(date: @start_date..@end_date)
          .where(result_point: @dmer_senbai1_start_date..@dmer_senbai1_end_date)
        if shift_digestion == 0 || shift_schedule == 0
          valuation_fin1_period_len = 0
          valuation_fin1_period = 0
          valuation_fin1 = 0
        else  
          valuation_fin1_period_len = ((result_dmer_sum - dmer_senbais_user_def.length - dmer_done_period.length).to_f / shift_digestion * shift_schedule * @dmer_senbai1_this_month_per).round()
          valuation_fin1 = 
            (@dmer_senbai1_price * valuation_fin1_period_len) + 
            (@dmer_senbai1_price * (dmer_done_period.length.to_f * @dmer_senbai1_this_month_per).round()) + 
            dmer_done.where(date: ...@start_date).where(result_point: @dmer_senbai1_start_date..@dmer_senbai1_end_date).sum(:valuation_new) rescue 0
        end
        # 日付が締め日を超えた時終着と現状売上を切り替える
        if (Date.today > @dmer_senbai1_closing_date) || valuation_current1 >= valuation_fin1
          valuation_fin1 = valuation_current1
        end 
        #成果1-----------------------------------------------
        #成果2-----------------------------------------------
        dmer_senbai_calc_valuation2 # 1次成果の期間、単価、成果になる率を取得
        # 成果2（アクセプタンス合格）の現状売
        # dメルで審査とアクセプタンス審査が通っている案件
        dmer_slmt_done = 
          dmer_senbais_slmter.where(industry_status: "OK").where(app_check: "OK")
          .where.not(dup_check: "重複").where(partner_status: "Active")
          .where(status: "審査OK").where(status_settlement: "完了").where(picture_check: "合格")
        valuation_current2_data =
          dmer_slmt_done.where(result_point: @dmer_senbai2_start_date..@dmer_senbai2_end_date)
            .where(picture_check_date: ..@dmer_senbai2_end_date).where.not(picture_check_date: nil)
            .or(
              dmer_slmt_done.where(picture_check_date: @dmer_senbai2_start_date..@dmer_senbai2_end_date)
              .where(result_point: ..@dmer_senbai2_end_date).where.not(picture_check_date: nil)
            )
          valuation_current2 = valuation_current2_data.sum(:valuation_settlement)
        # 成果2終着
        # 成果2終着2（期内）
        if shift_digestion == 0 || shift_schedule == 0
          valuation_fin2_period_len = 0
          valuation_fin2_period = 0
        else  
          dmer_slmt_done_period = valuation_current2_data.where(date: @start_date..@end_date)
          valuation_fin2_period_len = 
            ((result_dmer_sum - dmer_senbais_user_def.length - dmer_slmt_done_period.length).to_f / shift_digestion * shift_schedule * @dmer_senbai2_this_month_per).round()
          valuation_fin2_period = 
            (@dmer_senbai2_price * valuation_fin2_period_len) + 
            @dmer_senbai2_price * (dmer_slmt_done_period.length.to_f * @dmer_senbai2_this_month_per).round() rescue 0
        end
        # 過去月の決済対象
        dmer_slmt_tgt_prev = 
        dmer_done.where(settlement_deadline: @start_date..)
        .where(date: ...@start_date).where(settlement: nil)
        .where(picture_check_date: nil).where.not(status_settlement: "期限切れ")
        .or(
          dmer_done.where(settlement_deadline: @start_date.. )
          .where(date: ...@start_date)
          .where(settlement: @dmer1_start_date..@dmer1_end_date)
          .where(picture_check_date: nil).where.not(status_settlement: "期限切れ")
        )
        valuation_fin2_prev = 
          (@dmer_senbai2_price * (dmer_slmt_tgt_prev.length.to_f * @dmer_senbai2_prev_month_per).round()) +
          valuation_current2_data.where(date: ...@start_date).sum(:valuation_settlement) rescue 0
        # 日付が締め日を超えた時終着と現状売上を切り替える
        if (Date.today > @dmer_senbai2_closing_data) || (valuation_current2 >= (valuation_fin2_period + valuation_fin2_prev))
          valuation_fin2 = valuation_current2
        else  
          valuation_fin2 = valuation_fin2_period + valuation_fin2_prev
        end 
        #成果2-----------------------------------------------
        #成果3-----------------------------------------------
          dmer_senbai_calc_valuation3 # 3次成果の期間、単価、成果になる率を取得
          # 成果2（2回目決済）の現状売
          valuation_current3_data =
            dmer_slmt_done.where(result_point: @dmer_senbai3_start_date..@dmer_senbai3_end_date)
              .where(picture_check_date: ..@dmer_senbai3_end_date).where.not(picture_check_date: nil)
              .where(settlement_second: ..@dmer_senbai3_end_date).where.not(settlement_second: nil)
              .or(
                dmer_slmt_done.where(picture_check_date: @dmer_senbai3_start_date..@dmer_senbai3_end_date)
                .where(result_point: ..@dmer_senbai3_end_date).where.not(result_point: nil)
                .where(settlement_second: ..@dmer_senbai3_end_date).where.not(settlement_second: nil)
              )
              .or(
                dmer_slmt_done.where(settlement_second: @dmer_senbai3_start_date..@dmer_senbai3_end_date)
                .where(result_point: ..@dmer_senbai3_end_date).where.not(result_point: nil)
                .where(picture_check_date: ..@dmer_senbai3_end_date).where.not(picture_check_date: nil)
              )
        valuation_current3 = valuation_current3_data.sum(:valuation_second_settlement)
        # 成果3終着（期間内）
        if shift_digestion == 0 || shift_schedule == 0
          valuation_fin3_period_len = 0
          valuation_fin3_period = 0
        else  
          valuation_current3_period = valuation_current3_data.where(date: @start_date..@end_date)
          valuation_fin3_period_len = ((result_dmer_sum - dmer_senbais_user_def.length - valuation_current3_period.length).to_f / shift_digestion * shift_schedule * @dmer_senbai3_this_month_per).round()
          valuation_fin3_period = (@dmer_senbai3_price * valuation_fin3_period_len) + (@dmer_senbai3_price * (valuation_current3_period.length.to_f * @dmer_senbai3_this_month_per).round()) rescue 0
        end 
        valuation_fin3_prev = 
        (@dmer_senbai3_price * (dmer_slmt_tgt_prev.length.to_f * @dmer_senbai3_prev_month_per).round()) + 
        valuation_current3_data.where(date: ...@start_date).sum(:valuation_second_settlement) rescue 0
        if (Date.today > @dmer_senbai3_closing_data) || (valuation_current3 >= (valuation_fin3_period + valuation_fin3_prev))
          valuation_fin3 = valuation_current3
        else  
          valuation_fin3 = valuation_fin3_period + valuation_fin3_prev
        end 

        valuation_current = valuation_current1 + valuation_current2 + valuation_current3
        valuation_fin = valuation_fin1 + valuation_fin2 + valuation_fin3
          
      # 評価売-----------------------------------------------
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
        def_len: dmer_senbais_user_def.length              ,
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
