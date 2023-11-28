class SelectColumn < ApplicationRecord

  with_options presence: true do 
    validates :category
    validates :name
  end 
end
