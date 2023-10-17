FactoryBot.define do 
  factory :dmer do 
    customer_num { 12345678 }
    client { "マックス" }
    date { Date.today }
    status { "審査OK" }
    valuation_new { 8000 }
    valuation_settlement { 5000 }
    valuation_second_settlement { 5000 }
    profit_new { 8000 }
    profit_settlement { 5000 }
    profit_second_settlement { 5000 }
    association :user
    association :store_prop
  end 
end 