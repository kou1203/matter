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
  has_many :airpays 
  has_many :pandas 
  has_many :shifts
  has_many :results
  has_many :trouble_ns
  has_many :rakuten_casas
  has_many :n_results
  has_many :trouble_sses
  has_many :st_insurances
  has_many :rakuten_pays
  has_many :result_sales
  has_many :other_products
  has_many :demaekans
  has_many :summit_error_histories
  has_many :summit_customer_props
  has_many :summit_billing_amounts
  has_many :dmer_date_progress
  has_many :aupay_date_progress
  has_many :paypay_date_progress
  has_many :rakuten_pay_date_progress
  has_many :airpay_date_progress
  has_many :demaekan_date_progress
end
