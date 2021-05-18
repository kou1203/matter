class Summit < ApplicationRecord
  belongs_to :store_prop
  belongs_to :user 

  with_options presence: true do 
    validates :user_id
    validates :store_prop_id
    validates :get_date
    validates :status
    validates :claim_house 
    validates :claim_address 
    validates :menu  
    validates :start 
    validates :payment 
  end 
end
