class Comment < ApplicationRecord
  belongs_to :store_prop 

  with_options presence: true do 
    validates :store_prop_id
    validates :product
    validates :content
    validates :status
  end 
end
