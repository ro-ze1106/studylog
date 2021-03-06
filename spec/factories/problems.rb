FactoryBot.define do
  factory :problem do
    study_type { '算数' }
    title { '計算問題' }
    explanation_text { '□を計算して答えなさい。' }
    problem_text { '12×7＝□' }
    answer { '94' }
    problem_explanation { '人が1グループ12人いました。7グループだと何人ですか？' }
    target_age { 12 }
    reference { 'https://www.dainippon-tosho.co.jp/mext/e07.html' }
    association :user
    created_at { Time.current }
  end

  trait :yesterday do
    created_at { 1.day.ago }
  end

  trait :one_week_ago do
    created_at { 1.week.ago }
  end

  trait :one_month_ago do
    created_at { 1.month.ago }
  end

  trait :picture do
    picture { Rack::Test::UploadedFile.new('spec/fixtures/test_problem.png') }
  end
end
