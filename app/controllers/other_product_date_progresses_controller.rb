class OtherProductDateProgressesController < ApplicationController
  include CommonCalc
  def index 
    @month = params[:month] ? Time.parse(params[:month]) : Date.today
    @create_date = params[:create_d]
    @date_group = OtherProductDateProgress.where(product_name: @product_name).pluck(:date).uniq
    @create_group = OtherProductDateProgress.where(product_name: @product_name).pluck(:create_date).uniq
    @users = User.all
    if params[:date].present?
      @month = params[:date].to_date
    elsif params[:search_date].present?
      @month = params[:search_date].to_date  
    elsif OtherProductDateProgress.where(product_name: @product_name).where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date).present? 
      @month = OtherProductDateProgress.where(product_name: @product_name).where(date: @month.beginning_of_month..@month.end_of_month).maximum(:date)
    else
      @month = params[:month].to_date
    end 
    @product_name = params[:product_name]

    @current_progress = OtherProductDateProgress.where(product_name: @product_name).includes(:user).where(date: @month)
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
      @current_data_partner,@current_data_other, @current_data_retire
    ]
    if  @current_progress.present?
      @data_fin = [
        {
          name: "中部SS終着", data: OtherProductDateProgress.where(product_name: @product_name).where(base: "中部SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "関西SS終着", data: OtherProductDateProgress.where(product_name: @product_name).where(base: "関西SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "関東SS終着", data: OtherProductDateProgress.where(product_name: @product_name).where(base: "関東SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
        {
          name: "九州SS終着", data: OtherProductDateProgress.where(product_name: @product_name).where(base: "九州SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_fin)
        },
      ]
      @data_current = [
        {
          name: "中部SS現状売上", data: OtherProductDateProgress.where(product_name: @product_name).where(base: "中部SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "関西SS現状売上", data: OtherProductDateProgress.where(product_name: @product_name).where(base: "関西SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "関東SS現状売上", data: OtherProductDateProgress.where(product_name: @product_name).where(base: "関東SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
        {
          name: "九州SS現状売上", data: OtherProductDateProgress.where(product_name: @product_name).where(base: "九州SS").where(date: @month.beginning_of_month..@month.end_of_month).group(:date,:create_date).sum(:profit_current)
        },
      ]
    else
      @data = OtherProductDateProgress.none
    end

    # 比較対象
    if params[:comparison_date].present?
      @comparison_date = params[:comparison_date].to_date
      @comparison = 
      OtherProductDateProgress.where(product_name: @product_name).where(date: @comparison_date)
      @comparison =
        @comparison.where(create_date: @comparison.maximum(:create_date))
    else  
      if @current_progress.present?
        @comparison = 
        OtherProductDateProgress.where(product_name: @product_name).where(date: @current_progress.first.date.prev_month)
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
    @product_name = params[:product_name]
    @other_product_calc_period = @calc_periods.find_by(name: "各商材獲得")
    @start_date = start_date(@other_product_calc_period)
    @end_date = end_date(@other_product_calc_period)
    cnt = 0
    @other_products_group = OtherProduct.where(product_name: @product_name).where(date: @month.beginning_of_month..@month.end_of_month)
    @other_products_group.group(:user_id).each do |r|
      user_id = r.user_id
      @other_product_progress_data = OtherProductDateProgress.find_by(user_id: user_id,date: @month,create_date: Date.today,product_name: @product_name)
      # 獲得内訳
      @other_products_user = OtherProduct.where(product_name: @product_name).where(user_id: user_id).where(date: @start_date..@end_date)
      get_len = @other_products_user.sum(:product_len)
      @other_products_user_period = @other_products_user.where(date: @start_date..@end_date)
      shift_digestion =         
        Result.where(user_id: user_id)
        .where(date: ...Date.today)
        .where(date: @start_date..@end_date)
        .where(shift: "キャッシュレス新規").length
    # 現状売上
      valuation = 0
      profit = 0
    # 実売
      profit = @other_products_user.sum(:profit)
      valuation = @other_products_user.sum(:valuation)
      

      if r.user.position == "退職"
        user_base = r.user.position
      elsif r.user.base_sub == "キャッシュレス"
        user_base = r.user.base
      else  
        user_base = "その他"
      end 
    # Auステッカーの売上の中身
      other_product_progress_params = {
        product_name: @product_name                         ,
        user_id: user_id                                    ,
        base: user_base                                     ,
        date: @month                                        ,
        shift_digestion: shift_digestion                    ,
        get_len: get_len                                    ,
        result_len: get_len                                 ,
        fin_len: get_len                                    ,
        valuation_current: valuation                        ,
        valuation_fin: valuation                            ,
        profit_current: profit                              ,
        profit_fin: profit                                  ,
        create_date: Date.today
      }
    # 日付とユーザー名が一致しているデータの場合更新、新しいデータの場合保存
      if @other_product_progress_data.present?
        @other_product_progress_data.update(
          other_product_progress_params
        )
      else  
        @other_product_date_progress = OtherProductDateProgress.new(
          other_product_progress_params
        )
        @other_product_date_progress.save
      end
      cnt += 1    
    end 
    redirect_to calc_periods_path(month: @month) ,alert: "#{cnt}件#{@product_name}の売上結果を作成しました"


  end  

  def date_destroy
    @date_progress = OtherProductDateProgress.where(date: params[:month]).where(create_date: params[:create_d])
    @date_progress.destroy_all
    redirect_to other_product_date_progresses_path(month: params[:month]), alert: "#{params[:create_d]}に作成した進捗を削除しました。"
  end
end
