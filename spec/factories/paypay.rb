FactoryBot.define do 
  factory :paypay do 
    client {"マックスサポート"}
    date {Date.today}
    status {"60審査可決"}
    profit {3000}
    valuation {1000}
    association :user
    association :store_prop
    customer_num { "PKB006597" }
    status_update { Date.today }
    remarks { "後確OK" }
    result_point { Date.today }
  end 
end