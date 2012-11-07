require 'spec_helper'

describe "User" do

  subject { page }

  describe "my articles" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_content(user.username) }
    it { should have_content("no articles") }
    it { should have_link("Write article") }
    it { should have_selector('strong', text: "0")}

    describe "articles" do
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

  describe "other user's articles" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(other_user)
    end

    it { should have_content(other_user.username) }
    it { should have_content("no articles") }
    it { should_not have_link("Write article") }
  end
end