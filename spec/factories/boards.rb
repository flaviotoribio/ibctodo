FactoryBot.define do
  factory :board do
    name { Faker::Lorem.word }
    #sequence :position do |n|
    #  n
    #end
  end
end
