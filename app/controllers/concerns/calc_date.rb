module CalcDate
  extend ActiveSupport::Concern

  # 開始

  def start_date(calc_data_already_find_product)
     # 獲得期間の指定するのに使用
    # 期間 @basic_calc_data.start_date_monthは-1~1の値が入っている
    @basic_start_date_year_and_month = @month.since(calc_data_already_find_product.start_date_month.month)
    # start_date_dayが0の場合は月末、そうでない場合は指定した日付が入るようになっている
    # 獲得期間の開始する日付を生成
    if calc_data_already_find_product.start_date_day == 0
      start_date = Date.new(
        @basic_start_date_year_and_month.year,
        @basic_start_date_year_and_month.month,
        @basic_start_date_year_and_month.end_of_month.day,
      )
    else
      start_date = Date.new(
        @basic_start_date_year_and_month.year,
        @basic_start_date_year_and_month.month,
        calc_data_already_find_product.start_date_day,
      )
    end
  end 
  # 終了
  def end_date(calc_data_already_find_product)
    # 獲得期間の終了する日付を生成
    @basic_end_date_year_and_month = @month.since(calc_data_already_find_product.end_date_month.month)
    if calc_data_already_find_product.end_date_day == 0
      end_date = Date.new(
        @basic_end_date_year_and_month.year,
        @basic_end_date_year_and_month.month,
        @basic_end_date_year_and_month.end_of_month.day,
      )
    else
      end_date = Date.new(
        @basic_end_date_year_and_month.year,
        @basic_end_date_year_and_month.month,
        calc_data_already_find_product.end_date_day,
      )
    end
  end 
  #締め日
  def closing_date(calc_data_already_find_product)
    @basic_closing_date_year_and_month = @month.since(calc_data_already_find_product.closing_date_month.month)
    if calc_data_already_find_product.closing_date_day == 0
      @closing_date = Date.new(
        @basic_closing_date_year_and_month.year,
        @basic_closing_date_year_and_month.month,
        @basic_closing_date_year_and_month.end_of_month.day,
      )
    else
      @closing_date = Date.new(
        @basic_closing_date_year_and_month.year,
        @basic_closing_date_year_and_month.month,
        calc_data_already_find_product.closing_date_day,
      )
    end
  end 


end 