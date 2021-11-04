class Shift < ApplicationRecord
  belongs_to :user

  with_options presence: true do 
    validates :user_id
    validates :date
    validates :shift
    validates :availability, inclusion: { in: [true, false] }
  end 
end
