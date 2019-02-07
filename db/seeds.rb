require 'faker'

puts 'Create users'
10.times do
  User.create!(password: 'password', password_confirmation: 'password', email: Faker::Internet.email, nickname: Faker::Name.name)
end

puts 'Create posts'
60.times do
  Post.create!(user_id: rand(User.first.id..User.last.id), title: Faker::Lorem.word.capitalize,
               body: Faker::Lorem.sentence(rand(20..60)), published_at: Date.today - rand(0..5).days)
end

puts 'Create comments'
180.times do
  Comment.create!(user_id: rand(User.first.id..User.last.id), post_id: rand(Post.first.id..Post.last.id),
                  body: Faker::Lorem.sentence(rand(10..30)), published_at: Date.today - rand(0..5).days)
end
