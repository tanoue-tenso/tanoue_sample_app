User.create!(
  name:  "tanos",
  email: "example@railstutorial.org",
  password:              "testtest",
  password_confirmation: "testtest",
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "testtest"
  User.create!(
    name:  name,
    email: email,
    password:              password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
end

users = User.order(:created_at).take(6) # 作成時間が新しい６つのユーザーを取得
50.times do
  content = Faker::Lorem.sentence(5)
  users.each do |user|
    user.microposts.create!(content: content)
  end
end
