class Airpay < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :user 
  belongs_to :settlementer ,class_name: "User", optional: true
  belongs_to :store_prop 

  with_options presence: true do 
    validates :user_id
    validates :store_name
    validates :date 
    validates :status
    validates :customer_num
    validates :kr_code
    validates :ipad_flag
    validates :vm_status
    validates :vm_status_name
    validates :valuation
    validates :profit
  end 
end
