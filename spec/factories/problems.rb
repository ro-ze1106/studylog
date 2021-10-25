FactoryBot.define do
  factory :problem do
    study_type { "MyString" }
    picture { "MyString" }
    problem_text { "MyString" }
    answer { "MyText" }
    problem_explanation { "MyString" }
    target_age { 1 }
    reference { "MyText" }
  end
end
