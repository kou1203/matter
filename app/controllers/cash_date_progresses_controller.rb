class CashDateProgressesController < ApplicationController

  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @create_date = params[:create_d]
    @date_group = CashDateProgress.pluck(:date).uniq
    @users = User.all
    @create_group = CashDateProgress.pluck(:create_date).uniq
    if params[:date].present?
      @month = params[:date].to_date
    elsif params[:search_date].present?
      @month = params[:search_date].to_date  
    elsif CashDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date).present? 
      @month = CashDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date)
    else
      @month = params[:month].to_date
    end 

    @current_progress = 
    CashDateProgress.where(date: @month)
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
      @product_profit_current_graph =
        {
          "dメル" => @current_progress.sum(:dmer_profit_current),
          "auPay" => @current_progress.sum(:aupay_profit_current),
          "PayPay" => @current_progress.sum(:paypay_profit_current),
          "楽天ペイ" => @current_progress.sum(:rakuten_pay_profit_current),
          "AirPay" => @current_progress.sum(:airpay_profit_current),
          "auステッカー" => @current_progress.sum(:austicker_profit_current),
          "dメルステッカー" => @current_progress.sum(:dmersticker_profit_current)
        }
      @data_fin = [
        {
          name: "中部SS終着", data: CashDateProgress.where(base: "中部SS").group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "関西SS終着", data: CashDateProgress.where(base: "関西SS").group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "関東SS終着", data: CashDateProgress.where(base: "関東SS").group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "九州SS終着", data: CashDateProgress.where(base: "九州SS").group(:date,:create_date).sum(:profit_fin)
        },
      ]
      @data_current = [
        {
          name: "中部SS現状売上", data: CashDateProgress.where(base: "中部SS").group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "関西SS現状売上", data: CashDateProgress.where(base: "関西SS").group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "関東SS現状売上", data: CashDateProgress.where(base: "関東SS").group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "九州SS現状売上", data: CashDateProgress.where(base: "九州SS").group(:date,:create_date).sum(:profit_current)
        },
      ]
    else
      @data = CashDateProgress.none
    end

    # 比較対象
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
      @comparison = 
        CashDateProgress.where(date: @comparison_date)
      @comparison =
        @comparison.where(create_date: @comparison.maximum(:create_date))
    else  
      if @current_progress.present?
        @comparison = 
          CashDateProgress.where(date: @current_progress.first.date.prev_month)
        @comparison = 
          @comparison.where(create_date: @comparison.maximum(:create_date))
      else  
        @comparison = CashDateProgress.none
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
    cnt = 0
    @bases = [
      "中部SS", "関西SS", "関東SS", "九州SS",
      "フェムト", "サミット", "2次店", "退職"
    ]
    # @users = User.includes(
    #   :dmer_date_progress,
    #   :aupay_date_progress,
    #   :paypay_date_progress,
    #   :rakuten_pay_date_progress,
    #   :airpay_date_progress,
    #   :austicker_date_progress,
    #   :dmersticker_date_progress
    # )
    # @users = 
    #   @users.where.not(dmer_date_progresses: {id: nil})
    #   .or(
    #     @users.where.not(aupay_date_progresses: {id: nil})
        
    #   )
    #   .or(
    #     @users.where.not(paypay_date_progresses: {id: nil})
        
    #   )
    #   .or(
    #     @users.where.not(rakuten_pay_date_progresses: {id: nil})
        
    #   )
    #   .or(
    #     @users.where.not(airpay_date_progresses: {id: nil})
        
    #   )
    #   .or(
    #     @users.where.not(austicker_date_progresses: {id: nil})
        
    #   )
    #   .or(
    #     @users.where.not(dmersticker_date_progresses: {id: nil})
        
    #   )
    @shifts = Shift.where(start_time: @start_date..@end_date)
    @results = Result.where(date: @start_date..@end_date)
    # @users = User.all
    profit_current = 0
    profit_fin = 0
    Shift.group(:user_id).each do |shift|
      shift_schedule = @shifts.where(shift: "キャッシュレス新規").where(user_id: shift.user_id).length
      shift_digestion = @results.where(shift: "キャッシュレス新規").where(user_id: shift.user_id).length
      @cash_progress_data = 
        CashDateProgress.find_by(date: @month, user_id: shift.user_id,create_date: Date.today)
      dmer_date_progresses = DmerDateProgress.where(user_id: shift.user_id).where(date: @month)
      dmer_profit_current = dmer_date_progresses.sum(:profit_current)
      dmer_profit_fin = 
        dmer_date_progresses.sum(:profit_fin1) +
        dmer_date_progresses.sum(:profit_fin2) +
        dmer_date_progresses.sum(:profit_fin3)
      
      aupay_date_progresses = AupayDateProgress.where(user_id: shift.user_id).where(date: @month)
      aupay_profit_current = aupay_date_progresses.sum(:profit_current)
      aupay_profit_fin = 
        aupay_date_progresses.sum(:profit_fin)
      
      paypay_date_progresses = PaypayDateProgress.where(user_id: shift.user_id).where(date: @month)
      paypay_profit_current = paypay_date_progresses.sum(:profit_current)
      paypay_profit_fin = paypay_date_progresses.sum(:profit_fin)

      rakuten_pay_date_progresses = RakutenPayDateProgress.where(user_id: shift.user_id).where(date: @month)
      rakuten_pay_profit_current = rakuten_pay_date_progresses.sum(:profit_current)
      rakuten_pay_profit_fin = rakuten_pay_date_progresses.sum(:profit_fin)

      airpay_date_progresses = AirpayDateProgress.where(user_id: shift.user_id).where(date: @month)
      airpay_profit_current = airpay_date_progresses.sum(:profit_current)
      airpay_profit_fin = airpay_date_progresses.sum(:profit_fin)

      demaekan_date_progresses = DemaekanDateProgress.where(user_id: shift.user_id).where(date: @month)
      demaekan_profit_current = demaekan_date_progresses.sum(:profit_current)
      demaekan_profit_fin = demaekan_date_progresses.sum(:profit_fin)

      austicker_date_progresses = AustickerDateProgress.where(user_id: shift.user_id).where(date: @month)
      austicker_profit_current = austicker_date_progresses.sum(:profit_current)
      austicker_profit_fin = austicker_date_progresses.sum(:profit_fin)

      dmersticker_date_progresses = DmerstickerDateProgress.where(user_id: shift.user_id).where(date: @month)
      dmersticker_profit_current = dmersticker_date_progresses.sum(:profit_current)
      dmersticker_profit_fin = dmersticker_date_progresses.sum(:profit_fin)

      profit_current = 
        dmer_profit_current + aupay_profit_current + paypay_profit_current +
        rakuten_pay_profit_current + airpay_profit_current + demaekan_profit_current +
        austicker_profit_current + dmersticker_profit_current
      profit_fin = 
        dmer_profit_fin + aupay_profit_fin + paypay_profit_fin +
        rakuten_pay_profit_fin + airpay_profit_fin + demaekan_profit_fin +
        austicker_profit_fin + dmersticker_profit_fin


        if shift.user.position == "退職"
          user_base = shift.user.position
        elsif shift.user.base_sub == "キャッシュレス"
          user_base = shift.user.base
        else  
          user_base = shift.user.base_sub
        end 
    # 中身
      cash_progress_params = {
        user_id: shift.user_id                                          ,
        base: user_base                                           ,
        date: @month                                              ,
        shift_schedule: shift_schedule                            ,
        shift_digestion: shift_digestion                          ,
        dmer_profit_current: dmer_profit_current                  ,
        aupay_profit_current: aupay_profit_current                ,
        paypay_profit_current: paypay_profit_current              ,
        rakuten_pay_profit_current: rakuten_pay_profit_current    ,
        airpay_profit_current: airpay_profit_current              ,
        demaekan_profit_current: demaekan_profit_current          ,
        austicker_profit_current: austicker_profit_current        ,
        dmersticker_profit_current: dmersticker_profit_current    ,
        profit_current: profit_current                            ,
        dmer_profit_fin: dmer_profit_fin                          ,
        aupay_profit_fin: aupay_profit_fin                        ,
        paypay_profit_fin: paypay_profit_fin                      ,
        rakuten_pay_profit_fin: rakuten_pay_profit_fin            ,
        airpay_profit_fin: airpay_profit_fin                      ,
        demaekan_profit_fin: demaekan_profit_current                  ,
        austicker_profit_fin: austicker_profit_current                ,
        dmersticker_profit_fin: dmersticker_profit_current            ,
        profit_fin: profit_fin                                    ,
        create_date: Date.today
      }
    # 日付とユーザー名が一致しているデータの場合更新、新しいデータの場合保存
      if @cash_progress_data.present?
        @cash_progress_data.update(
          cash_progress_params
        )
      else  
        @cash_date_progress = CashDateProgress.new(
          cash_progress_params
        )
        @cash_date_progress.save
      end
      cnt += 1    
    end 
    redirect_to calc_periods_path(month: @month) ,alert: "#{cnt}件キャッシュ合計売上結果を作成しました"


  end  
end
