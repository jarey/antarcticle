FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:first_name) { |n| "John#{n}" }
    sequence(:last_name) { |n| "Smith#{n}" }

    factory :admin do
      admin true
    end
  end

  factory :article do
    sequence(:title) { |n| "Article #{n} title" }
    content "Lorem ipsum"
    user
  end
end
