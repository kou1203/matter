class Shift < ApplicationRecord
  belongs_to :user

  with_options presence: true do 
    validates :user_id
    validates :start_time
    validates :shift
  end 
end
