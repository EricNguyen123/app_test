# frozen_string_literal: true

FactoryBot.define do
  factory :remember_room do
    user_id { Faker::Number.number(digits: 6) }
    chat_room_id { Faker::Number.number(digits: 6) }
  end
end
