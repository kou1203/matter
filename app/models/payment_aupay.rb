class PaymentAupay < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :aupay , optional: true
  with_options presence: true do 
    validates :payment
  end
end
