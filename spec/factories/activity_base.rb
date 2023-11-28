FactoryBot.define do 
  factory :activity_base do 
    date { Date.today }
    association :user
    base { '中部SS' }
    position { '05:一般' }
  end 
end 