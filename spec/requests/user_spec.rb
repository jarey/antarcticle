require 'spec_helper'

describe "User" do

  subject { page }

  describe "articles" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_content(user.username) }

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
