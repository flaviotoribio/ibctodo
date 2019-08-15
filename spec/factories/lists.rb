FactoryBot.define do
  factory :list do
    name { Faker::Lorem.word }
    sequence :position do |n|
      n
    end
  end
end
