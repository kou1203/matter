class SpreadLink < ApplicationRecord
  with_options presence: true do 
    validates :year
    validates :month
    validates :original_url
    validates :search_url
  end
end
