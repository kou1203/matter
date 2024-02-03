class TypeReferenceValue < ApplicationRecord
  belongs_to :result
  with_options presence: true do 
    validates :result_id 
  end 
end
