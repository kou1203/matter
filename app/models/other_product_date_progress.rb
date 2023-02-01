class OtherProductDateProgress < ApplicationRecord
  belongs_to :user 

  with_options presence: true do 
    validates :product_name
    validates :user_id 
    validates :date
    validates :create_date
  end 
end
