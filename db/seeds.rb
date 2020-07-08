User.create!(
  name:  "tanos",
  email: "example@railstutorial.org",
  password:              "testtest",
  password_confirmation: "testtest",
  admin: true
)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "testtest"
  User.create!(name:  name,
      email: email,
      password:              password,
      password_confirmation: password)
end