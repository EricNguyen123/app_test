FactoryBot.define do
  factory :user do
    uid { '123456' }
    provider { 'some_provider' }

    name { 'John Doe' }
    email { 'john@example.com' }
    password { 'password' }
  end
end
