# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password = Faker::Internet.password(min_length: 8)
    email_address { Faker::Internet.email }
    password { password }
    password_confirmation { password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
