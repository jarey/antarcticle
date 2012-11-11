require 'spec_helper'
require 'cancan/matchers'

describe "authorization" do
  subject { ability }
  let(:ability) { Ability.new(user) }

  describe "guest" do
    let(:user) { nil }

    it { should_not be_able_to(:manage, :all) }
    it { should be_able_to(:read, :all) }
  end

  describe "user" do
    let(:user) { FactoryGirl.build(:user) }
    let(:users_article) { FactoryGirl.build(:article, user: user) }
    let(:other_users_article) { FactoryGirl.build(:article) }

    it { should be_able_to(:read, :all) }
    it { should be_able_to(:update, users_article) }
    it { should be_able_to(:destroy, users_article) }
    it { should_not be_able_to(:update, other_users_article) }
    it { should_not be_able_to(:destroy, other_users_article) }
    it { should be_able_to(:create, Article) }
  end

  describe "admin" do
    let(:user) { FactoryGirl.build(:admin) }

    it { should be_able_to(:manage, :all) }
  end

end

