class OtherProduct < ApplicationRecord
  belongs_to :user

  with_options presence: true do 
    validates :user_id 
    validates :product_name
    validates :product_len
    validates :date
    validates :profit
    validates :valuation
  end 
end
