require 'spec_helper'

describe "User" do

  subject { page }

  describe "profile" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end

    describe "user info" do
      it { should have_content user.username }

      context "when user with filled first and last name" do
        it { should have_selector '.name' }
        it { should have_content user.first_name }
        it { should have_content user.last_name }
      end

      context "when user without filled first and last name" do
        let(:user) { FactoryGirl.create(:user, first_name: nil, last_name: nil) }

        it { should_not have_selector '.name' }
      end

      it "includes articles count" do
        should have_selector ".numbers li", text: "Articles"
      end
    end

    describe "articles" do
      context "is empty" do
        it { should have_content "no articles" }

        it "shows 0 in articles counter" do
          should have_selector 'strong', text: "0"
        end

        context "when visited by user" do
          it { should have_link "Write article" }
        end

        context "when visited by guest" do
          before { sign_out }
          it { should_not have_link "Write article" }
        end
      end

      context "is not empty" do
        before do
          @article = FactoryGirl.create(:article, user: user)
          visit user_path(user)
        end

        it { should have_content @article.title }
        it { should_not have_content "no articles" }
        it { should_not have_link "Write article" }

        it "shows articles count" do
          should have_selector 'strong', text: "1"
        end
      end
    end

    describe "tags filter" do
      before do
        @article1 = FactoryGirl.create(:article, user: user, tag_list: "tag1, tag2")
        @article2 = FactoryGirl.create(:article, user: user, tag_list: "tag1, tag2")
        @article3 = FactoryGirl.create(:article, tag_list: "tag1, tag2")
      end

      context "filled" do
        before do
          visit user_path(user)
          fill_in 'tags_filter', with: "tag1,tag2"
          click_button "Find"
        end

        it "stays on same page" do
          current_path.should == user_path(user)
        end

        it "shows user articles tagged with 'tag1' and 'tag2'" do
          should have_content @article1.title
          should have_content @article2.title
        end

        it "doesnt show articles of other user tagged with 'tag1' and 'tag2'" do
          should_not have_content @article3.title
        end
      end

      context "is empty" do
        before do
          @article4 = FactoryGirl.create(:article, user: user, tag_list: "")
          visit user_path(user)
          fill_in 'tags_filter', with: ""
          click_button "Find"
        end

        it "stays on same page" do
          current_path.should == user_path(user)
        end

        it "shows all articles of this user" do
          should have_content @article1.title
          should have_content @article2.title
          should have_content @article4.title
        end
      end
    end
  end
end
