require 'spec_helper'

describe "Articles" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "article creation" do
    before { visit new_article_path }

    it { should have_selector('h2', text: "New article") }
    it { should have_placeholder('Enter article content here ...') }
    it { should have_placeholder('Article title') }
    it { should have_button('Post') }

    describe "valid data" do
      before do
        fill_in_placeholder 'Article title', 'article1 title'
        fill_in_placeholder 'Enter article content here ...', "Lorem ipsum"
      end

      it "should create an article" do
        expect { click_button "Post" }.to change(Article, :count).by(1)
      end

      describe "created article" do
        before { click_button "Post" }
        it { current_path.should == article_path(1) }
        #should have_selector('div.alert.alert-success', text: "Article was successfully created")
        it { should have_content("Article was successfully created") }
      end
    end

    describe "invalid data" do
      it "should not create an article" do
        expect { click_button "Post" }.not_to change(Article, :count)
      end

      describe "errors" do
        before { click_button "Post" }
        it { should have_error_message('Title') }
      end
    end
  end
end
