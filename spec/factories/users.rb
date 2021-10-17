FactoryBot.define do
  factory :user do
    name { 'MyString' }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
