class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :dmers
  has_many :pranesses
  has_one :stock_history
  has_one :return_history
  has_many :summits
  has_many :aupays
  has_many :paypays 
  has_many :pandas 
  has_many :shifts
  has_many :results
  has_many :trouble_ns
  has_many :rakuten_casas
  has_many :n_results
  has_many :trouble_sses
end
