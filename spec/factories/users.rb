FactoryBot.define do
  factory :user do
    uid {Faker::Number.number(digits: 6) }
    provider { Faker::Omniauth.google[:provider] }

    name {Faker::Name.name  }
    email {Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
  end
end
