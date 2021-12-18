FactoryBot.define do
  factory :notification do
    user_id { 1 }
    problem_id { 1 }
    variety { 1 }
    content { "MyText" }
    from_user_id { 1 }
  end
end
