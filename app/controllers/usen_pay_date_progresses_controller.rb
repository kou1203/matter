class UsenPayDateProgressesController < ApplicationController
  include CommonCalc
  def index 
    @profit_price = CalcPeriod.where(sales_category: "実売").find_by(name: "UsenPay").price
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @create_date = params[:create_d]
    @date_group = OtherProductDateProgress.where(product_name: "UsenPay").pluck(:date).uniq
    @create_group = OtherProductDateProgress.where(product_name: "UsenPay").pluck(:create_date).uniq
    @users = User.all
    if params[:date].present?
      @month = params[:date].to_date
    elsif params[:search_date].present?
      @month = params[:search_date].to_date  
    elsif OtherProductDateProgress.where(product_name: "UsenPay").where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date).present? 
      @month = OtherProductDateProgress.where(product_name: "UsenPay").where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date)
    else
      @month = params[:month].to_date
    end 

    @current_progress = OtherProductDateProgress.where(product_name: "UsenPay").includes(:user).where(date: @month)
    if params[:create_d].present?
      @current_progress = 
        @current_progress.where(create_date: params[:create_d].to_date)
    else
      @current_progress = 
        @current_progress.where(date: @month).where(create_date: @current_progress.maximum(:create_date))
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
      @current_data_partner,@current_data_other, @current_data_summit, @current_data_retire
    ]
    if  @current_progress.present?
      @data_fin = [
        {
          name: "中部SS終着", data: OtherProductDateProgress.where(product_name: "UsenPay").where(base: "中部SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "関西SS終着", data: OtherProductDateProgress.where(product_name: "UsenPay").where(base: "関西SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "関東SS終着", data: OtherProductDateProgress.where(product_name: "UsenPay").where(base: "関東SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "九州SS終着", data: OtherProductDateProgress.where(product_name: "UsenPay").where(base: "九州SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
      ]
      @data_current = [
        {
          name: "中部SS現状売上", data: OtherProductDateProgress.where(product_name: "UsenPay").where(base: "中部SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "関西SS現状売上", data: OtherProductDateProgress.where(product_name: "UsenPay").where(base: "関西SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "関東SS現状売上", data: OtherProductDateProgress.where(product_name: "UsenPay").where(base: "関東SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "九州SS現状売上", data: OtherProductDateProgress.where(product_name: "UsenPay").where(base: "九州SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
      ]
    else
      @data = OtherProductDateProgress.none
    end

    # 比較対象
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
      @comparison = 
      OtherProductDateProgress.where(product_name: "UsenPay").where(date: @comparison_date)
      @comparison =
        @comparison.where(create_date: @comparison.maximum(:create_date))
    else  
      if @current_progress.present?
        @comparison = 
        OtherProductDateProgress.where(product_name: "UsenPay").where(date: @current_progress.first.date.prev_month)
        @comparison = 
          @comparison.where(create_date: @comparison.maximum(:create_date))
      else  
        @comparison = OtherProductDateProgress.none
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
    @month = params[:month].to_date
    if Date.today > @month
      @month = @month.end_of_month
    elsif Date.today < @month
      @month = @month.beginning_of_month
    else 
      @month = Date.today
    end 
    calc_profit

    cnt = 0
    @usen_payes_group = UsenPay.where(date: @month.ago(6.month).beginning_of_month..@month.end_of_month)
    @usen_payes_group.group(:user_id).each do |i_user|
      calc_profit
      usen_pay_period = @calc_periods.find_by(name: "UsenPay")
      usen_pay_totalling_period = @calc_periods.find_by(name: "UsenPay獲得")
      usen_pay_totalling_start_date = start_date(usen_pay_totalling_period)
      usen_pay_totalling_end_date = end_date(usen_pay_totalling_period)
      usen_start_date = start_date(usen_pay_period)
      usen_end_date = end_date(usen_pay_period)
      usen_pay_closing_date = closing_date(usen_pay_period)
      usen_pay_price = usen_pay_period.price
      usen_pay_this_month_per = usen_pay_period.this_month_per

      user_id = i_user.user_id
      @usen_pay_progress_data = OtherProductDateProgress.where(product_name: "UsenPay").find_by(user_id: user_id,date: @month,create_date: Date.today)
      # 獲得内訳
      shifts = Shift.where(user_id: user_id).where(start_time: @start_date..@end_date).where(shift: "キャッシュレス新規").length
      results = 
        Result.where(user_id: user_id)
        .where(date: ...Date.today)
        .where(date: @start_date..@end_date)
        .where(shift: "キャッシュレス新規").length
      usen_pay_user = UsenPay.where(user_id: user_id)
      usen_pay_user_period = usen_pay_user.where(date: @start_date..@end_date)
      get_len = usen_pay_user_period.length
      fin_len = (get_len.to_f / results * shifts).round() rescue 0
      usen_pay_user_result = usen_pay_user.where(result_point: usen_start_date..usen_end_date).where(status: "入金待ち")
      result_len = usen_pay_user_result.length
      usen_fin_target_len = 
        usen_pay_user.where(date: usen_pay_totalling_start_date..usen_pay_totalling_end_date).where(status: "不備解消中")
        .or(
          usen_pay_user.where(date: usen_pay_totalling_start_date..usen_pay_totalling_end_date).where(status: "書類確認待ち")
        ).length
    # 現状売上
      valuation_current = 0
      profit_current = 0
    # 実売
      profit_current = usen_pay_user_result.sum(:profit)
    # 終着
        profit_fin = profit_current + ((usen_fin_target_len.to_f * usen_pay_this_month_per).round() * usen_pay_price)
        if Date.today >= usen_pay_closing_date
          profit_fin = profit_current
        end 
    # 評価売
      # 7月より前の案件
      calc_valuation
      usen_pay_period = @calc_periods.find_by(name: "UsenPay")
      usen_pay_totalling_start_date = start_date(usen_pay_totalling_period)
      usen_pay_totalling_end_date = end_date(usen_pay_totalling_period)
      usen_start_date = start_date(usen_pay_period)
      usen_end_date = end_date(usen_pay_period)
      usen_pay_closing_date = closing_date(usen_pay_period)
      usen_pay_price = usen_pay_period.price
      usen_pay_this_month_per = usen_pay_period.this_month_per
      usen_separate_date = Date.new(2023,8,1)
      valuation_current_7month_ago = usen_pay_user_result.where(date: ...usen_separate_date).sum(:valuation) rescue 0
      # 8月以降の案件
      valuation_current_8month_since = usen_pay_user_period.where.not(status: "自社不備").where.not(status: "自社NG").where(date: usen_separate_date..).sum(:valuation) rescue 0
      valuation_current = valuation_current_7month_ago + valuation_current_8month_since rescue 0
      valuation_fin = usen_pay_price * (fin_len.to_f * usen_pay_this_month_per).round() rescue 0
      if Date.today >= usen_pay_closing_date
        valuation_fin = valuation_current
      end 
      if i_user.user.position == "退職"
        user_base = i_user.user.position
      elsif i_user.user.base_sub == "キャッシュレス"
        user_base = i_user.user.base
      else  
        user_base = "その他"
      end 
    # UsenPayの売上の中身
      usen_pay_progress_params = {
        product_name: "UsenPay"                             ,
        user_id: user_id                                    ,
        base: user_base                                     ,
        date: @month                                        ,
        shift_digestion: results                            ,
        get_len: get_len                                    ,
        fin_len: fin_len                                    ,
        result_len: result_len                              ,
        valuation_current: valuation_current                ,
        valuation_fin: valuation_fin                        ,
        profit_current: profit_current                      ,
        profit_fin: profit_fin                              ,
        create_date: Date.today
      }
    # 日付とユーザー名が一致しているデータの場合更新、新しいデータの場合保存
      if @usen_pay_progress_data.present?
        @usen_pay_progress_data.update(
          usen_pay_progress_params
        )
      else  
        @usen_pay_date_progress = OtherProductDateProgress.new(
          usen_pay_progress_params
        )
        @usen_pay_date_progress.save
      end
      cnt += 1    
    end 
    redirect_to calc_periods_path(month: @month) ,alert: "#{cnt}件UsenPay売上結果を作成しました"


  end  

  def date_destroy
    @date_progress = OtherProductDateProgress.where(product_name: "UsenPay").where(date: params[:month]).where(create_date: params[:create_d])
    @date_progress.destroy_all
    redirect_to usen_pay_date_progresses_path(month: params[:month]), alert: "#{params[:create_d]}に作成した進捗を削除しました。"
   end
end
