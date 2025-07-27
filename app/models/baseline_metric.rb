class BaselineMetric < ApplicationRecord

  belongs_to :baseline_sale

  with_options presence: true do 
    validates :baseline_sale_id
    validates :metric_name
    validates :metric_val
  end

end
