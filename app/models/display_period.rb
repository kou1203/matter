class DisplayPeriod < ApplicationRecord
  with_options presence: true do 
    validates :start_period_01
    validates :end_period_01
    validates :start_period_02
    validates :end_period_02
    validates :start_period_03
    validates :end_period_03
  end
end
