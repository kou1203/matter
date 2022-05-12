class Cost < ApplicationRecord
  with_options presence: true do 
    validates :year
    validates :month
    validates :group
    validates :base
    validates :sales_man
    validates :office_worker
    validates :social_insurance
    validates :administrator
    validates :sales_man_cost
    validates :office_worker_cost
    validates :office
    validates :utility_net_cost
    validates :dorm
    validates :bonus_stock
    validates :travel_stock
    validates :other
  end
end
