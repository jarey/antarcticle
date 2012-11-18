namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_tags
    make_articles
  end
end

def make_users
  update_user("user_1", ["John", "Smith"])
  admin = update_user("admin")
  admin.admin = true
  admin.save

  10.times do |n|
    name = Faker::Name.name.split(" ")
    username = Faker::Internet.user_name
    update_user(username, name)
  end
end

def update_user(username, name)
  User.find_or_initialize_by_username(username).tap do |u|
    u.first_name = name[0]
    u.last_name = name[1]
    u.save!
  end
end

def make_articles
  users = User.all.sample(5)
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
