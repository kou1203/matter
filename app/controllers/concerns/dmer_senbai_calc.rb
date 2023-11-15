module DmerSenbaiCalc
  extend ActiveSupport::Concern
  # CommonCalcと一緒に使用
  included do 
  end 
  
  # 評価売 calc_valuationの下に配置
  def dmer_senbai_calc_valuation1
    @dmer_senbai1_calc_data = @calc_periods.find_by(name: "dメル専売成果1")
    @dmer_senbai1_start_date = start_date(@dmer_senbai1_calc_data)
    @dmer_senbai1_end_date = end_date(@dmer_senbai1_calc_data)
    @dmer_senbai1_closing_date = closing_date(@dmer_senbai1_calc_data)
    @dmer_senbai1_this_month_per = @dmer_senbai1_calc_data.this_month_per
    @dmer_senbai1_prev_month_per = @dmer_senbai1_calc_data.prev_month_per
    @dmer_senbai1_price = @dmer_senbai1_calc_data.price
  end
  def dmer_senbai_calc_valuation2
    @dmer_senbai2_calc_data = @calc_periods.find_by(name: "dメル専売成果2")
    @dmer_senbai2_start_data = start_date(@dmer_senbai2_calc_data)
    @dmer_senbai2_end_data = end_date(@dmer_senbai2_calc_data)
    @dmer_senbai2_closing_data = closing_date(@dmer_senbai2_calc_data)
    @dmer_senbai2_this_month_per = @dmer_senbai2_calc_data.this_month_per
    @dmer_senbai2_prev_month_per = @dmer_senbai2_calc_data.prev_month_per
    @dmer_senbai2_price = @dmer_senbai2_calc_data.price
  end
  def dmer_senbai_calc_valuation3
    @dmer_senbai3_calc_data = @calc_periods.find_by(name: "dメル専売成果3")
    @dmer_senbai3_start_data = start_date(@dmer_senbai3_calc_data)
    @dmer_senbai3_end_data = end_date(@dmer_senbai3_calc_data)
    @dmer_senbai3_closing_data = closing_date(@dmer_senbai3_calc_data)
    @dmer_senbai3_this_month_per = @dmer_senbai3_calc_data.this_month_per
    @dmer_senbai3_prev_month_per = @dmer_senbai3_calc_data.prev_month_per
    @dmer_senbai3_price = @dmer_senbai3_calc_data.price
  end

  # 実売 calc_profitの下に配置
  def dmer_senbai_calc_profit
    @dmer_senbai_docomo_calc_data = @calc_periods.find_by(name: "dメル専売（ドコモ）成果")
    @dmer_senbai_docomo_start_date = start_date(@dmer_senbai_docomo_calc_data)
    @dmer_senbai_docomo_end_date = end_date(@dmer_senbai_docomo_calc_data)
    @dmer_senbai_docomo_closing_date = closing_date(@dmer_senbai_docomo_calc_data)
    @dmer_senbai_docomo_this_month_per = @dmer_senbai_docomo_calc_data.this_month_per
    @dmer_senbai_docomo_prev_month_per = @dmer_senbai_docomo_calc_data.prev_month_per
    @dmer_senbai_docomo_price = @dmer_senbai_docomo_calc_data.price
    @dmer_senbai_media_calc_data = @calc_periods.find_by(name: "dメル専売（メディア）成果")
    @dmer_senbai_media_start_date = start_date(@dmer_senbai_media_calc_data)
    @dmer_senbai_media_end_date = end_date(@dmer_senbai_media_calc_data)
    @dmer_senbai_media_closing_date = closing_date(@dmer_senbai_media_calc_data)
    @dmer_senbai_media_this_month_per = @dmer_senbai_media_calc_data.this_month_per
    @dmer_senbai_media_prev_month_per = @dmer_senbai_media_calc_data.prev_month_per
    @dmer_senbai_media_price = @dmer_senbai_media_calc_data.price
  end 
end 