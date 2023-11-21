class ReversalProduct < ApplicationRecord
  belongs_to :user
  
  with_options presence: true do 
    validates :prduct
    validates :store_name
    validates :user_id
    validates :date
    validates :result_date
    validates :reversal_date
    validates :price
  end 
end
