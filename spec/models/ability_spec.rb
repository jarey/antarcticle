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

    it { should be_able_to(:read, :all) }

    describe "article" do
      it { should be_able_to(:create, Article) }

      context "his own" do
        let(:users_article) { FactoryGirl.build(:article, user: user) }
        it { should be_able_to(:update, users_article) }
        it { should be_able_to(:destroy, users_article) }
      end

      context "others" do
        let(:other_users_article) { FactoryGirl.build(:article) }
        it { should_not be_able_to(:update, other_users_article) }
        it { should_not be_able_to(:destroy, other_users_article) }
      end
    end

    describe "comment" do
      it { should be_able_to(:create, Comment) }

      context "his own" do
        let(:users_comment) { FactoryGirl.build(:comment, user: user) }
        it { should be_able_to(:update, users_comment) }
        it { should be_able_to(:destroy, users_comment) }
      end

      context "others" do
        let(:other_users_comment) { FactoryGirl.build(:comment) }
        it { should_not be_able_to(:update, other_users_comment) }
        it { should_not be_able_to(:destroy, other_users_comment) }
      end
    end

  end

  describe "admin" do
    let(:user) { FactoryGirl.build(:admin) }

    it { should be_able_to(:manage, :all) }
  end

end

