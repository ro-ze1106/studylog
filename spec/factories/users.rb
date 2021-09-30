FactoryBot.define do
  factory :user do
    name { "MyString" }
    sequence(:email) { "example@example.com" }
  end
end
