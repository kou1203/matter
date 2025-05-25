class DealAttribute < ApplicationRecord
  belongs_to :result_type, inverse_of: :deal_attributes
  with_options presence: true do 
    validates :key
  end
end
