# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password = Faker::Internet.password(min_length: 8)
    email_address { Faker::Internet.email }
    password { password }
    password_confirmation { password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    # TODO: use and test below??
    # trait :with_synopses do
    #   after(:create) do |user|
    #     create_list(:synopsis, 3, user: user)
    #   end
    # end

    # trait :with_ratings do
    #   after(:create) do |user|
    #     create_list(:rating, 3, user: user)
    #   end
    # end

    # trait :with_synopsis_votes do
    #   after(:create) do |user|
    #     create_list(:synopsis_vote, 3, user: user)
    #   end
    # end
  end
end
