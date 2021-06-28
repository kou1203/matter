class TroubleSs < ApplicationRecord
  belongs_to :user 
  belongs_to :store_prop

  with_options presence: true do 
    validates :date
    validates :store_prop_id
    validates :category
    validates :customer_name 
    validates :get_status
    validates :product
    validates :user_id
    validates :confirmer
    validates :content_type
    validates :customer_opinion
  end 
end
