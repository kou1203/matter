class DmerStock < ApplicationRecord

  with_options presence: true do 
    validates :client 
    validates :base
    validates :date
    validates :stock_len
  end 

end
