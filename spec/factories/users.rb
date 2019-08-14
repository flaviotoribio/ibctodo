FactoryBot.define do
  factory :user do
    #first_name { Faker::Name::first_name }
    #last_name { Faker::Name::last_name }
    sequence(:email) {|n| "user#{n}@test.com" }
    password { Faker::Internet.password(min_length: 6) }
  end
end
