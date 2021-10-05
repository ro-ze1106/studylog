FactoryBot.define do
  factory :user do
    name { 'MyString' }
    sequence(:email) { 'example@example.com' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
