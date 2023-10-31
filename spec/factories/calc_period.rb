FactoryBot.define do 
  factory :calc_period do 
    name { "各商材獲得" }
    sales_category { "評価売" }
    start_date_month { 1 }
    start_date_day { 1 }
    end_date_month { 1 }
    end_date_day { 0 }
    closing_date_month { 2 }
    closing_date_day { 1 }
    this_month_per { 0.6 }
    prev_month_per { 0.8 }
    price { 5000 }
  end 
end 