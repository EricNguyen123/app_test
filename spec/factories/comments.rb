FactoryBot.define do
  factory :comment do
    content { "MyText" }
    user_id { 1 }
    micropost_id { "MyString" }
  end
end
