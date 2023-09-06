class NuroPayment < ApplicationRecord
  belongs_to :nuro
  with_options presence: true do 
    validates :nuro_id
    validates :category
    validates :isp_num
    validates :name   
    validates :service
    validates :payment  
    validates :price
  end 

  
end
