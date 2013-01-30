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
    sequence(:content) { |n| "Lorem ipsum #{n}" }
    user
  end

  factory :comment do
    sequence(:content) { |n| "Comment content #{n}" }
    user
    article
  end
end
