class BaselineSale < ApplicationRecord

  has_many :baseline_metrics

  with_options presence: true do 
    validates :sales_goal
  end

end
