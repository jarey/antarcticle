namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_articles
  end
end

def make_users
  User.create!(username: "user_1")

  10.times do |n|
    name = Faker::Name.name
    User.create!(name: name)
  end
end

def make_articles
  users = User.all(limit: 4)
  30.times do
    content = Faker::Lorem.sentences(10)
    title = Faker::Name.title
    users.sample(1)[0].articles.create!(ttile: title, content: content)
  end
end
