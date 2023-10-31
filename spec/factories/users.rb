FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { 'taro' }
    base { '中部SS' }
    base_sub { 'キャッシュレス' }
    password { 'password' }
    password_confirmation { 'password' }
    position_sub { '05：一般' }
  end
end