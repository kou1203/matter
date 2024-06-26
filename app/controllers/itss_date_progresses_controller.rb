class ItssDateProgressesController < ApplicationController

  def index 
    @profit_price = CalcPeriod.where(sales_category: "実売").find_by(name: "ITSS").price
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @create_date = params[:create_d]
    @date_group = OtherProductDateProgress.where(product_name: "ITSS").pluck(:date).uniq
    @create_group = OtherProductDateProgress.where(product_name: "ITSS").pluck(:create_date).uniq
    @users = User.all
    if params[:date].present?
      @month = params[:date].to_date
    elsif params[:search_date].present?
      @month = params[:search_date].to_date  
    elsif OtherProductDateProgress.where(product_name: "ITSS").where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date).present? 
      @month = OtherProductDateProgress.where(product_name: "ITSS").where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date)
    else
      @month = params[:month].to_date
    end 

    @current_progress = OtherProductDateProgress.where(product_name: "ITSS").includes(:user).where(date: @month)
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
          name: "中部SS終着", data: OtherProductDateProgress.where(product_name: "ITSS").where(base: "中部SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "関西SS終着", data: OtherProductDateProgress.where(product_name: "ITSS").where(base: "関西SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "関東SS終着", data: OtherProductDateProgress.where(product_name: "ITSS").where(base: "関東SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "九州SS終着", data: OtherProductDateProgress.where(product_name: "ITSS").where(base: "九州SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
      ]
      @data_current = [
        {
          name: "中部SS現状売上", data: OtherProductDateProgress.where(product_name: "ITSS").where(base: "中部SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "関西SS現状売上", data: OtherProductDateProgress.where(product_name: "ITSS").where(base: "関西SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "関東SS現状売上", data: OtherProductDateProgress.where(product_name: "ITSS").where(base: "関東SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "九州SS現状売上", data: OtherProductDateProgress.where(product_name: "ITSS").where(base: "九州SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
      ]
    else
      @data = OtherProductDateProgress.none
    end

    # 比較対象
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
      @comparison = 
      OtherProductDateProgress.where(product_name: "ITSS").where(date: @comparison_date)
      @comparison =
        @comparison.where(create_date: @comparison.maximum(:create_date))
    else  
      if @current_progress.present?
        @comparison = 
        OtherProductDateProgress.where(product_name: "ITSS").where(date: @current_progress.first.date.prev_month)
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
    @itsses_group = Shift.group(:user_id)
    @itsses_group.group(:user_id).each do |i_user|
      @calc_periods = CalcPeriod.where(sales_category: "実売")
      calc_period_and_per
      user_id = i_user.user_id
      @itss_progress_data = OtherProductDateProgress.where(product_name: "ITSS").find_by(user_id: user_id,date: @month,create_date: Date.today)
      # 獲得内訳
      @itss_user = Itss.where(user_id: user_id)
      @itss_user_period = @itss_user.where(date: @start_date..@end_date)
      get_len = @itss_user_period.length
      @itss_user_result = @itss_user.where(construction_schedule: @itss1_start_date..@itss1_end_date).where(status_ntt1: "工事完了")
      result_len = @itss_user_result.length
    # 現状売上
      valuation_current = 0
      profit_current = 0
    # 実売
      profit_current = @itss_user_result.sum(:profit)
    # 終着
        profit_fin = profit_current
      
      @calc_periods = CalcPeriod.where(sales_category: "評価売")
      calc_period_and_per
      valuation_current = @itss_user_result.sum(:valuation)

      if i_user.user.position == "退職"
        user_base = i_user.user.position
      elsif i_user.user.base_sub == "キャッシュレス"
        user_base = i_user.user.base
      else  
        user_base = i_user.user.base_sub
      end 
    # ITSSの売上の中身
      itss_progress_params = {
        product_name: "ITSS"                                ,
        user_id: user_id                                    ,
        base: user_base                                     ,
        date: @month                                        ,
        get_len: get_len                                    ,
        result_len: result_len                              ,
        valuation_current: valuation_current                ,
        valuation_fin: valuation_current                    ,
        profit_current: profit_current                      ,
        profit_fin: profit_current                          ,
        create_date: Date.today
      }
    # 日付とユーザー名が一致しているデータの場合更新、新しいデータの場合保存
      if @itss_progress_data.present?
        @itss_progress_data.update(
          itss_progress_params
        )
      else  
        @itss_date_progress = OtherProductDateProgress.new(
          itss_progress_params
        )
        @itss_date_progress.save
      end
      cnt += 1    
    end 
    redirect_to calc_periods_path(month: @month) ,alert: "#{cnt}件ITSS売上結果を作成しました"


  end  

  def date_destroy
    @date_progress = OtherProductDateProgress.where(product_name: "ITSS").where(date: params[:month]).where(create_date: params[:create_d])
    @date_progress.destroy_all
    redirect_to itss_date_progresses_path(month: params[:month]), alert: "#{params[:create_d]}に作成した進捗を削除しました。"
   end
end
