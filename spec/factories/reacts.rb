# frozen_string_literal: true

FactoryBot.define do
  factory :react do
    action { Faker::Markdown.emphasis }
    user_id { Faker::Number.number(digits: 6) }
    micropost_id { Faker::Number.number(digits: 6) }
  end
end
