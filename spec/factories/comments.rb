FactoryBot.define do
  factory :comment do
    user_id { 1 }
    content { '難しい' }
    association :problem
  end
end
