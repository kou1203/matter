class Shift < ApplicationRecord
  belongs_to :user

  with_options presence: true do 
    validates :user_id
    validates :year
    validates :month
    validates :house_work
    validates :ojt
    validates :cashless_new
    validates :n
    validates :rakuten_casa
    validates :cashless_settlement
    validates :praness
    validates :summit
    validates :panda
    validates :goal
  end 
end
