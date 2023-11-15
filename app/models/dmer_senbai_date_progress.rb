class DmerSenbaiDateProgress < ApplicationRecord
  belongs_to :user

  with_options presence: true do 
    validates :user_id
    validates :base
    validates :date
    validates :shift_schedule
    validates :shift_schedule_slmt
    validates :shift_digestion
    validates :shift_digestion_slmt
    validates :get_len
    validates :def_len
    validates :fin_len
    validates :valuation_current
    validates :valuation_current1
    validates :valuation_current2
    validates :valuation_current3
    validates :valuation_fin
    validates :valuation_fin1
    validates :valuation_fin2
    validates :valuation_fin3
    validates :profit_current
    validates :profit_fin
    validates :create_date
  end
end
