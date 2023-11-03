class DmerSenbaiUser < ApplicationRecord
  belongs_to :user
  
  with_options presence: true do 
    validates :user_id
    validates :client
    validates :date
  end 
end
