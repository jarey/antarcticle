require 'spec_helper'

describe "User" do

  subject { page }

  describe "articles" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end

    describe "header" do
      it { should have_content(user.username) }

      context "user with filled first and last name" do
        it { should have_selector('.name') }
        it { should have_content(user.first_name) }
        it { should have_content(user.last_name) }
      end

      context "user with not filled first and last name" do
        let(:user) { FactoryGirl.create(:user, first_name: nil, last_name: nil) }

        it { should_not have_selector('.name') }
      end
    end

    context "is empty" do
      it { should have_content("no articles") }
      it { should have_selector('strong', text: "0")}

      context "when visited by user" do
        it { should have_link("Write article") }
      end

      context "when visited by guest" do
        before { sign_out }
        it { should_not have_link("Write article") }
      end
    end

    context "is not empty" do
      before do
        @article = FactoryGirl.create(:article, user: user)
        visit user_path(user)
      end

      it { should have_content(@article.title) }
      it { should_not have_content("no articles")}
      it { should_not have_link("Write article") }
      it { should have_selector('strong', text: "1")}
    end
  end
end
