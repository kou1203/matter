class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :dmers
  has_many :pranesses
  has_one :stock_history
  has_one :return_history
  has_one :summit
  has_one :aupay
  has_one :paypay 
        
end
