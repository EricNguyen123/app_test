FactoryBot.define do
  factory :user do
    uid {Faker::Number.number(digits: 6) }
    provider { 'some_provider' }

    name { 'John Doe' }
    email { 'john@example.com' }
    password { 'password' }
  end
end
