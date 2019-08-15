FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@test.com" }
    password { Faker::Internet.password(min_length: 6) }
  end
end
