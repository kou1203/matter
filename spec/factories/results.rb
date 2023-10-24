FactoryBot.define do 
  factory :result do 
    association :user 
    association :ojt, factory: :user
    date {Date.today}
    area {"hoge"}
    shift {"キャッシュレス新規"}
    first_total_visit {0}
    first_visit { 1 }
    first_interview { 2 }
    first_full_talk { 3 }
    first_get { 4 }
    latter_total_visit {0}
    latter_visit { 1 }
    latter_interview { 2 }
    latter_full_talk { 3 }
    latter_get { 4 }
    cafe_visit { 6 }
    cafe_get { 7 }
    other_food_visit { 6 }
    other_food_get { 7 }
    car_visit { 6 }
    car_get { 7 }
    other_retail_visit { 6 }
    other_retail_get { 7 }
    hair_salon_visit { 6 }
    hair_salon_get { 7 }
    manipulative_visit { 6 }
    manipulative_get { 7 }
    other_service_visit { 6 }
    other_service_get { 7 }
  end 
end 