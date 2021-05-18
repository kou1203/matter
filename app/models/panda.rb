class Panda < ApplicationRecord

  with_options presence: true do 
    validates :customer_num
    validates :client
    validates :user_id
    validates :store_prop_id
    validates :get_date
    validates :status
    validates :image_status 
    validates :food_category
    validates :ghost_flag
    with_options uniqueness: true do 
      validates :customer_num
    end 
  end 
  belongs_to :store_prop 
  belongs_to :user 
  
end
