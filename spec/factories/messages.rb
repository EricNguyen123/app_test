# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    message { Faker::Markdown.emphasis }
  end
end
