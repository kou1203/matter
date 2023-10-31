FactoryBot.define do 
  factory :aupay do 
    customer_num { 12345678 }
    client { "メディア" }
    date { Date.today }
    status { "審査通過" }
    valuation_new { 0 }
    valuation_settlement { 4000 }
    profit_new { 0 }
    profit_settlement { 5000 }
    association :user
    association :settlementer,factory: :user
    association :store_prop
  end 
end 