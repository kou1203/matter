class DemaekanDateProgress < ApplicationRecord

  belongs_to :user 

  with_options presence: true do 
    validates :user_id 
    validates :date
    validates :create_date

  end 
end
