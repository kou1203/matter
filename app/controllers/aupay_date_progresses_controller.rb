class AupayDateProgressesController < ApplicationController

  def index 
    @profit_price = CalcPeriod.where(sales_category: "実売").find_by(name: "auPay成果1").price
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @create_date = params[:create_d]
    @date_group = AupayDateProgress.pluck(:date).uniq
    @create_group = AupayDateProgress.pluck(:create_date).uniq
    @users = User.all
    if params[:date].present?
      @month = params[:date].to_date
    elsif params[:search_date].present?
      @month = params[:search_date].to_date  
    elsif AupayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date).present? 
      @month = AupayDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date)
    else
      @month = params[:month].to_date
    end 

    @current_progress = 
    AupayDateProgress.includes(:user).where(date: @month)
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
      @data_fin = [
        {
          name: "中部SS終着", data: AupayDateProgress.where(base: "中部SS").group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "関西SS終着", data: AupayDateProgress.where(base: "関西SS").group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "関東SS終着", data: AupayDateProgress.where(base: "関東SS").group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "九州SS終着", data: AupayDateProgress.where(base: "九州SS").group(:date,:create_date).sum(:profit_fin)
        },
      ]
      @data_current = [
        {
          name: "中部SS現状売上", data: AupayDateProgress.where(base: "中部SS").group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "関西SS現状売上", data: AupayDateProgress.where(base: "関西SS").group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "関東SS現状売上", data: AupayDateProgress.where(base: "関東SS").group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "九州SS現状売上", data: AupayDateProgress.where(base: "九州SS").group(:date,:create_date).sum(:profit_current)
        },
      ]
    else
      @data = AupayDateProgress.none
    end

    # 比較対象
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
      @comparison = 
        AupayDateProgress.where(date: @comparison_date)
      @comparison =
        @comparison.where(create_date: @comparison.maximum(:create_date))
    else  
      if @current_progress.present?
        @comparison = 
          AupayDateProgress.where(date: @current_progress.first.date.prev_month)
        @comparison = 
          @comparison.where(create_date: @comparison.maximum(:create_date))
      else  
        @comparison = AupayDateProgress.none
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
    else 
      @month = Date.today
    end 
    @calc_periods = CalcPeriod.where(sales_category: "実売")
    calc_period_and_per
    @results = Result.where(date: @start_date..@end_date).where(shift: "キャッシュレス新規")
    @shifts = Shift.where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規")
    cnt = 0
    @aupays_group = Aupay.where(date: @start_date.prev_month..@end_date).group(:user_id)
    @aupays_group.group(:user_id).each do |r|
      @calc_periods = CalcPeriod.where(sales_category: "実売")
      calc_period_and_per
      user_id = r.user_id
      @aupay_progress_data = AupayDateProgress.find_by(user_id: user_id,date: @month,create_date: Date.today)
      shift_schedule = @shifts.where(user_id: user_id).length
      shift_digestion = @results.where(user_id: user_id).length
    # 獲得内訳
      @aupays_user = Aupay.where(user_id: user_id)
      @aupays_slmter = Aupay.where(settlementer_id: user_id)
      @aupays_user_period = @aupays_user.where(date: @start_date..@end_date)
      # 申込取消or不備対応中or審査NGor社内確認中
      @aupays_user_def = 
        @aupays_user_period.where(status: "自社不備")
        .or(@aupays_user_period.where(status: "不合格"))
        .or(@aupays_user_period.where(status: "差し戻し"))
        .or(@aupays_user_period.where(status: "解約"))
        .or(@aupays_user_period.where(status: "報酬対象外"))
        .or(@aupays_user_period.where(status: "重複対象外"))
        .or(@aupays_user_period.where(status: "本店審査待ち"))
      # 不備・NGを引いた獲得数
      @aupays_len = @aupays_user_period.length - @aupays_user_def.length
      @aupays_fin_len = (@aupays_len.to_f / shift_digestion * shift_schedule).round() rescue 0
      # 審査待ち
      aupay_wait = @aupays_user_period.where(status: "審査待ち")
      aupay_wait_prev = aupay_wait.where(date: ...@start_date)
      # 審査完了
      aupay_done = 
        @aupays_user.where(result_point: @aupay1_start_date..@aupay1_end_date)
        .where(status: "審査通過")
      aupay_done_prev = aupay_done.where(date: ...@start_date)
      # 過去月の決済対象
      aupay_slmt_tgt_prev = 
      @aupays_user.where(settlement_deadline: @start_date.. )
      .where(date: ...@start_date)
      .where(status: "審査通過")
      .where(status_update_settlement: nil)
      aupay_slmt_tgt_prev_len = aupay_slmt_tgt_prev.length rescue 0
    # 決済期限切れ
      aupay_slmt_dead_len = aupay_slmt_tgt_prev.where(status_settlement: "期限切れ").length
    # 現状売上
      valuation_current = 0
      profit_current = 0
    # 実売
      aupay_result = 
        @aupays_slmter.where(status_update_settlement: @aupay1_start_date..@aupay1_end_date)
        .where(status: "審査通過")
        .where(status_settlement: "完了")
      profit_current = aupay_result.sum(:profit_settlement)
      aupay_result_len = aupay_result.length 
    # 終着（過去）
      aupay_result_fin_prev_month_len = 
        (
          aupay_slmt_tgt_prev_len * @aupay1_prev_month_per
        ).round() rescue 0

        profit_fin = 
        (@aupay1_price * aupay_result_fin_prev_month_len) + 
        (
          (aupay_result.where("? > date", @start_date).length.to_f * @aupay1_prev_month_per
        ).round() * @aupay1_price) rescue 0
      
      result_fin_len = profit_fin / @aupay1_price
      if (profit_current > profit_fin) || (Date.today > @closing_date)
        profit_fin = profit_current
        result_fin_len = aupay_result.length
      end 
      @calc_periods = CalcPeriod.where(sales_category: "評価売")
      calc_period_and_per
      valuation_current = aupay_result.sum(:valuation_settlement)
      valuation_fin = 
      (@aupay1_price * aupay_result_fin_prev_month_len) + 
      (
        (aupay_result.where("? > date", @start_date).length.to_f * @aupay1_prev_month_per
      ).round() * @aupay1_price) rescue 0
      if (valuation_current > valuation_fin) || (Date.today > @closing_date)
        valuation_fin = valuation_current
      end 

      if r.user.position == "退職"
        user_base = r.user.position
      elsif r.user.base_sub == "キャッシュレス"
        user_base = r.user.base
      else  
        user_base = r.user.base_sub
      end 
    # auPayの売上の中身
      aupay_progress_params = {
        user_id: user_id                                    ,
        base: user_base                                     ,
        date: @month                                        ,
        shift_schedule: shift_schedule                      ,
        shift_digestion: shift_digestion                    ,
        get_len: @aupays_user_period.length                 ,
        wait_len: aupay_wait.length                         ,
        done_len: aupay_done.length                         ,
        slmt_dead_len: aupay_slmt_dead_len                  ,
        def_len: @aupays_user_def.length                    ,
        fin_len: @aupays_fin_len                            ,
        valuation_current: valuation_current                ,
        valuation_fin: valuation_fin                        ,
        valuation_fin_prev: valuation_fin                   ,
        profit_current: profit_current                      ,
        profit_fin: profit_fin                              ,
        result_fin_len: result_fin_len                      ,
        profit_fin_prev: profit_fin                         ,
        result_len: aupay_result.length                     ,
        slmt_tgt_prev: aupay_slmt_tgt_prev_len              ,
        done_len_prev: aupay_done_prev.length               ,
        create_date: Date.today
      }
    # 日付とユーザー名が一致しているデータの場合更新、新しいデータの場合保存
      if @aupay_progress_data.present?
        @aupay_progress_data.update(
          aupay_progress_params
        )
      else  
        @aupay_date_progress = AupayDateProgress.new(
          aupay_progress_params
        )
        @aupay_date_progress.save
      end
      cnt += 1    
    end 
    redirect_to calc_periods_path(month: @month) ,alert: "#{cnt}件auPay売上結果を作成しました"


  end 
end