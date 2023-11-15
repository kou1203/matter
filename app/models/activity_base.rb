class ActivityBase < ApplicationRecord
  belongs_to :user
  with_options presence: true do 
    validates :date
    validates :user_id
    validates :base
    validates :position
  end 
end
