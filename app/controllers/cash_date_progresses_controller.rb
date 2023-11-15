class CashDateProgressesController < ApplicationController

  def index 
    # 基本設定
      @month = params[:month] ? Time.parse(params[:month]) : Date.today
      @create_date = params[:create_d]
      @date_group = CashDateProgress.pluck(:date).uniq
      @users = User.all
      @create_group = CashDateProgress.pluck(:create_date).uniq
    # 日付検索
      if params[:date].present?
        @month = params[:date].to_date
      elsif params[:search_date].present?
        @month = params[:search_date].to_date  
      elsif CashDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date).present? 
        @month = CashDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date)
      else
        @month = params[:month].to_date
      end 
    # 比較対象検索
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
    # 作成日を変更
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
    if  @current_progress.present?
      # 円グラフ
        @product_profit_current_graph = {
            "dメル" => @current_progress.sum(:dmer_profit_current),
            "auPay" => @current_progress.sum(:aupay_profit_current),
            "PayPay" => @current_progress.sum(:paypay_profit_current),
            "楽天ペイ" => @current_progress.sum(:rakuten_pay_profit_current),
            "AirPay" => @current_progress.sum(:airpay_profit_current),
            "auステッカー" => @current_progress.sum(:austicker_profit_current),
            "dメルステッカー" => @current_progress.sum(:dmersticker_profit_current)
        }
      # 折線グラフ
        @graph_bases = ["全体","2次店"]
        User.where("base LIKE ?","%SS%").group(:base).each do |user|
          @graph_bases << user.base
        end
        @data_fin = []
        @data_fin_val = []
        @data_current = []
        @graph_bases.each do |base|
          if base == "全体"
            @data_fin << {
              name: "#{base}終着", 
              data: CashDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:create_date).sum(:profit_fin)
            }
            @data_fin_val << {
              name: "#{base}終着", 
              data: CashDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:create_date).sum(:valuation_fin)
            }
            @data_current << {
              name: "#{base}現状売上", 
              data: CashDateProgress.where(date: @month.beginning_of_month..@month.end_of_month).group(:create_date).sum(:profit_current)
            }
          else  
            @data_fin << {
              name: "#{base}終着", 
              data: CashDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:create_date).sum(:profit_fin)
            }
            @data_fin_val << {
              name: "#{base}終着", 
              data: CashDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:create_date).sum(:valuation_fin)
            }
            @data_current << {
              name: "#{base}現状売上", 
              data: CashDateProgress.where(base: base).where(date: @month.beginning_of_month..@month.end_of_month).group(:create_date).sum(:profit_current)
            }
          end 
        end
    else
      @data = CashDateProgress.none
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
    cnt = 0
    @bases = [
      "中部SS", "関西SS", "関東SS", "九州SS",
      "フェムト", "サミット", "2次店", "退職"
    ]
    @shifts = Shift.where(start_time: @start_date..@end_date)
    @results = Result.where(date: @start_date..@end_date)
    # @users = User.all
    profit_current = 0
    profit_fin = 0
    Shift.group(:user_id).each do |shift|
      shift_schedule = @shifts.where(shift: "キャッシュレス新規").where(user_id: shift.user_id).length + @shifts.where(shift: "キャッシュレス決済").where(user_id: shift.user_id).length
      shift_digestion = @results.where(shift: "キャッシュレス新規").where(user_id: shift.user_id).length + @results.where(shift: "キャッシュレス決済").where(user_id: shift.user_id).length
      @cash_progress_data = 
        CashDateProgress.find_by(date: @month, user_id: shift.user_id,create_date: Date.today)
      dmer_date_progresses = DmerDateProgress.where(user_id: shift.user_id).where(date: @month)
      dmer_date_progresses = dmer_date_progresses.where(create_date: dmer_date_progresses.maximum(:create_date))
      dmer_profit_current = dmer_date_progresses.sum(:profit_current)
      dmer_profit_fin = 
        dmer_date_progresses.sum(:profit_fin1) +
        dmer_date_progresses.sum(:profit_fin2) +
        dmer_date_progresses.sum(:profit_fin3)
      dmer_valuation_current = dmer_date_progresses.sum(:valuation_current)
      dmer_valuation_fin = 
        dmer_date_progresses.sum(:valuation_fin1) +
        dmer_date_progresses.sum(:valuation_fin2) +
        dmer_date_progresses.sum(:valuation_fin3)

        # d専売
        if DmerSenbaiDateProgress.where(user_id: shift.user_id).where(date: @month).present?
          dmer_senbai_date_progresses = DmerSenbaiDateProgress.where(user_id: shift.user_id).where(date: @month)
          dmer_senbai_date_progresses = dmer_senbai_date_progresses.where(create_date: dmer_date_progresses.maximum(:create_date))
          dmer_senbai_valuation_current = dmer_senbai_date_progresses.sum(:valuation_current)
          dmer_senbai_valuation_fin = dmer_senbai_date_progresses.sum(:valuation_fin)
          dmer_senbai_profit_current = dmer_senbai_date_progresses.sum(:profit_current)
          dmer_senbai_profit_fin = dmer_senbai_date_progresses.sum(:profit_fin)
        else  
          dmer_senbai_valuation_current = 0
          dmer_senbai_valuation_fin = 0
          dmer_senbai_profit_current = 0
          dmer_senbai_profit_fin = 0

        end
      
      aupay_date_progresses = AupayDateProgress.where(user_id: shift.user_id).where(date: @month)
      aupay_date_progresses = aupay_date_progresses.where(create_date: aupay_date_progresses.maximum(:create_date))
      aupay_profit_current = aupay_date_progresses.sum(:profit_current)
      aupay_profit_fin = 
        aupay_date_progresses.sum(:profit_fin)
      aupay_valuation_current = aupay_date_progresses.sum(:valuation_current)
      aupay_valuation_fin = 
        aupay_date_progresses.sum(:valuation_fin)
      
      paypay_date_progresses = PaypayDateProgress.where(user_id: shift.user_id).where(date: @month)
      paypay_date_progresses = paypay_date_progresses.where(create_date: paypay_date_progresses.maximum(:create_date))
      paypay_profit_current = paypay_date_progresses.sum(:profit_current)
      paypay_profit_fin = paypay_date_progresses.sum(:profit_fin)
      paypay_valuation_current = paypay_date_progresses.sum(:valuation_current)
      paypay_valuation_fin = paypay_date_progresses.sum(:valuation_fin)

      rakuten_pay_date_progresses = RakutenPayDateProgress.where(user_id: shift.user_id).where(date: @month)
      rakuten_pay_date_progresses = rakuten_pay_date_progresses.where(create_date: rakuten_pay_date_progresses.maximum(:create_date))
      rakuten_pay_profit_current = rakuten_pay_date_progresses.sum(:profit_current)
      rakuten_pay_profit_fin = rakuten_pay_date_progresses.sum(:profit_fin)
      rakuten_pay_valuation_current = rakuten_pay_date_progresses.sum(:valuation_current)
      rakuten_pay_valuation_fin = rakuten_pay_date_progresses.sum(:valuation_fin)

      airpay_date_progresses = AirpayDateProgress.where(user_id: shift.user_id).where(date: @month)
      airpay_date_progresses = airpay_date_progresses.where(create_date: airpay_date_progresses.maximum(:create_date))
      airpay_profit_current = airpay_date_progresses.sum(:profit_current)
      airpay_profit_fin = airpay_date_progresses.sum(:profit_fin)
      airpay_valuation_current = airpay_date_progresses.sum(:valuation_current)
      airpay_valuation_fin = airpay_date_progresses.sum(:valuation_fin)

      demaekan_date_progresses = DemaekanDateProgress.where(user_id: shift.user_id).where(date: @month)
      demaekan_date_progresses = demaekan_date_progresses.where(create_date: demaekan_date_progresses.maximum(:create_date))
      demaekan_profit_current = demaekan_date_progresses.sum(:profit_current)
      demaekan_profit_fin = demaekan_date_progresses.sum(:profit_fin)
      demaekan_valuation_current = demaekan_date_progresses.sum(:valuation_current)
      demaekan_valuation_fin = demaekan_date_progresses.sum(:valuation_fin)

      austicker_date_progresses = AustickerDateProgress.where(user_id: shift.user_id).where(date: @month)
      austicker_date_progresses = austicker_date_progresses.where(create_date: austicker_date_progresses.maximum(:create_date))
      austicker_profit_current = austicker_date_progresses.sum(:profit_current)
      austicker_profit_fin = austicker_date_progresses.sum(:profit_fin)
      austicker_valuation_current = austicker_date_progresses.sum(:valuation_current)
      austicker_valuation_fin = austicker_date_progresses.sum(:valuation_fin)

      dmersticker_date_progresses = DmerstickerDateProgress.where(user_id: shift.user_id).where(date: @month)
      dmersticker_date_progresses = dmersticker_date_progresses.where(create_date: dmersticker_date_progresses.maximum(:create_date))
      dmersticker_profit_current = dmersticker_date_progresses.sum(:profit_current)
      dmersticker_profit_fin = dmersticker_date_progresses.sum(:profit_fin)
      dmersticker_valuation_current = dmersticker_date_progresses.sum(:valuation_current)
      dmersticker_valuation_fin = dmersticker_date_progresses.sum(:valuation_fin)

      airpaysticker_date_progresses = AirpaystickerDateProgress.where(user_id: shift.user_id).where(date: @month)
      airpaysticker_date_progresses = airpaysticker_date_progresses.where(create_date: airpaysticker_date_progresses.maximum(:create_date))
      airpaysticker_profit_current = airpaysticker_date_progresses.sum(:profit_current)
      airpaysticker_profit_fin = airpaysticker_date_progresses.sum(:profit_fin)
      airpaysticker_valuation_current = airpaysticker_date_progresses.sum(:valuation_current)
      airpaysticker_valuation_fin = airpaysticker_date_progresses.sum(:valuation_fin)

      # その他商材
      other_product_date_progresses = OtherProductDateProgress.where(user_id: shift.user_id).where(date: @month)
      other_product_date_progresses = other_product_date_progresses.where(create_date: other_product_date_progresses.maximum(:create_date))
      other_product_profit_current = other_product_date_progresses.sum(:profit_current)
      other_product_profit_fin = other_product_date_progresses.sum(:profit_fin)
      other_product_valuation_current = other_product_date_progresses.sum(:valuation_current)
      other_product_valuation_fin = other_product_date_progresses.sum(:valuation_fin)

      profit_current = 
        dmer_profit_current + aupay_profit_current + paypay_profit_current +
        rakuten_pay_profit_current + airpay_profit_current + demaekan_profit_current +
        austicker_profit_current + dmersticker_profit_current + airpaysticker_profit_current +
        other_product_profit_current
      profit_fin = 
        dmer_profit_fin + aupay_profit_fin + paypay_profit_fin +
        rakuten_pay_profit_fin + airpay_profit_fin + demaekan_profit_fin +
        austicker_profit_fin + dmersticker_profit_fin + airpaysticker_profit_fin +
        other_product_profit_fin
      valuation_current = 
        dmer_valuation_current + aupay_valuation_current + paypay_valuation_current +
        rakuten_pay_valuation_current + airpay_valuation_current + demaekan_valuation_current +
        austicker_valuation_current + dmersticker_valuation_current + airpaysticker_valuation_current +
        other_product_valuation_current
      valuation_fin = 
        dmer_valuation_fin + aupay_valuation_fin + paypay_valuation_fin +
        rakuten_pay_valuation_fin + airpay_valuation_fin + demaekan_valuation_fin +
        austicker_valuation_fin + dmersticker_valuation_fin + airpaysticker_valuation_fin +
        other_product_valuation_fin

      other_profit_current = airpaysticker_profit_current + other_product_profit_current
      other_profit_fin = airpaysticker_profit_fin + other_product_profit_fin

      other_valuation_current = airpaysticker_valuation_current + other_product_valuation_current
      other_valuation_fin = airpaysticker_valuation_fin + other_product_valuation_fin

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
        # 実売
        dmer_profit_current: dmer_profit_current + dmer_senbai_profit_current                 ,
        aupay_profit_current: aupay_profit_current                ,
        paypay_profit_current: paypay_profit_current              ,
        rakuten_pay_profit_current: rakuten_pay_profit_current    ,
        airpay_profit_current: airpay_profit_current              ,
        demaekan_profit_current: demaekan_profit_current          ,
        austicker_profit_current: austicker_profit_current        ,
        dmersticker_profit_current: dmersticker_profit_current    ,
        profit_current: profit_current                            ,
        dmer_profit_fin: dmer_profit_fin + dmer_senbai_profit_fin                         ,
        aupay_profit_fin: aupay_profit_fin                        ,
        paypay_profit_fin: paypay_profit_fin                      ,
        rakuten_pay_profit_fin: rakuten_pay_profit_fin            ,
        airpay_profit_fin: airpay_profit_fin                      ,
        demaekan_profit_fin: demaekan_profit_current                  ,
        austicker_profit_fin: austicker_profit_current                ,
        dmersticker_profit_fin: dmersticker_profit_current            ,
        profit_fin: profit_fin                                        ,
        other_profit_current: other_profit_current                    ,
        other_profit_fin: other_profit_fin                            ,
        # 評価売
        dmer_valuation_current: dmer_valuation_current + dmer_senbai_valuation_current                  ,
        aupay_valuation_current: aupay_valuation_current                ,
        paypay_valuation_current: paypay_valuation_current              ,
        rakuten_pay_valuation_current: rakuten_pay_valuation_current    ,
        airpay_valuation_current: airpay_valuation_current              ,
        demaekan_valuation_current: demaekan_valuation_current          ,
        austicker_valuation_current: austicker_valuation_current        ,
        dmersticker_valuation_current: dmersticker_valuation_current    ,
        valuation_current: valuation_current                            ,
        dmer_valuation_fin: dmer_valuation_fin + dmer_senbai_valuation_fin                         ,
        aupay_valuation_fin: aupay_valuation_fin                        ,
        paypay_valuation_fin: paypay_valuation_fin                      ,
        rakuten_pay_valuation_fin: rakuten_pay_valuation_fin            ,
        airpay_valuation_fin: airpay_valuation_fin                      ,
        demaekan_valuation_fin: demaekan_valuation_current              ,
        austicker_valuation_fin: austicker_valuation_current            ,
        dmersticker_valuation_fin: dmersticker_valuation_current        ,
        valuation_fin: valuation_fin                                    ,
        other_valuation_current: other_valuation_current                ,
        other_valuation_fin: other_valuation_fin                        ,
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

  def date_destroy
    @date_progress = CashDateProgress.where(date: params[:month]).where(create_date: params[:create_d])
    @date_progress.destroy_all
    redirect_to cash_date_progresses_path(month: params[:month]), alert: "#{params[:create_d]}に作成した進捗を削除しました。"
   end

end
