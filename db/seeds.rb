User.create!(name:  "Tomo",
             email: "sample@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@example.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

10.times do |n|
  Problem.create!(user_id: 1,
                  study_type: "算数",
                  problem_text: "□を計算して答えなさい。                  12×7＝□",
                  answer: "94",
                  problem_explanation: "人が1グループ12人いました。                  7グループだと何人ですか？",
                  target_age: 12,
                  reference: "https://www.dainippon-tosho.co.jp/mext/e07.html",
                  user_id: 1)
end