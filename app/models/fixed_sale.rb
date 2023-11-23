class FixedSale < ApplicationRecord

  with_options presence: true do 
    validates :name
    validates :base
    validates :date
    validates :price
  end 

end
