class CalcPeriod < ApplicationRecord

  with_options presence: true do 
    # 商材名
    validates :name
    validates :sales_category
    # 獲得期間
    validates :start_date_month  ,numericality: {only_integer: true, greater_than_or_equal_to: -1, less_than_or_equal_to: 2}
    validates :start_date_day    ,numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 30}
    validates :end_date_month    ,numericality: {only_integer: true, greater_than_or_equal_to: -1, less_than_or_equal_to: 2}
    validates :end_date_day      ,numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 30}
    # 締め日
    validates :closing_date_month,numericality: {only_integer: true, greater_than_or_equal_to: -1, less_than_or_equal_to: 2}
    validates :closing_date_day  ,numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 30}
  end  

  def this_moth_per_float
    this_month_per.to_f / 100
  end 
  def prev_moth_per_float
    prev_month_per.to_f / 100
  end 

  def set_month_per_float
    {:this_month_per => this_moth_per_float,:prev_month_per => prev_moth_per_float }
  end 
end
