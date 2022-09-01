class ProductTarget < ApplicationRecord
  with_options presence: true do 
    validates :date 
    validates :product
    validates :base
    validates :product_len
  end
end
