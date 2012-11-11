namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_tags
    make_articles
  end
end

def make_users
  User.create!(username: "user_1")
  admin = User.create!(username: "admin")
  admin.toggle!(:admin)

  10.times do |n|
    username = Faker::Internet.user_name
    User.create!(username: username)
  end
end

def make_articles
  users = User.all(limit: 4)
  30.times do
    content = Faker::Lorem.paragraph(10)
    title = Faker::Name.title
    tags = Tag.all.sample(4).map(&:name).join(",")
    users.sample(1)[0].articles.create!(title: title, content: content, tag_list: tags)
  end
end

def make_tags
  10.times do
    tag = Faker::Lorem.word
    Tag.find_or_create_by_name(tag)
  end
end
