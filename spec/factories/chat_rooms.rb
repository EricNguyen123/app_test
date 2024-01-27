# frozen_string_literal: true

FactoryBot.define do
  factory :chat_room do
    title { Faker::Markdown.emphasis }
  end
end
