FactoryBot.define do 
  factory :store_prop do 
    race { "個人" }
    name { "hoge" }
    gender_main { "男性" }
    person_main_name { "foo" }
    person_main_kana { "フー" }
    phone_number_1 { "09012345678" }
    mail_1 { "hogehoge" }
    prefecture { "愛知県" }
    city { "名古屋市" }
    municipalities { "今池" }
    address { "1-1" }
  end 
end 