FactoryBot.define do 
  factory :result do 
    body { Faker::Lorem.characters(number:20) }
    user
  end 
end 