FactoryBot.define do
  factory :author do
    name { Faker::Name.name }
    bio { Faker::Lorem.sentence }
  end
end
