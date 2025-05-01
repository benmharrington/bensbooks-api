FactoryBot.define do
  factory :book do
    title { Faker::Name.name }
    association :author
  end
end
