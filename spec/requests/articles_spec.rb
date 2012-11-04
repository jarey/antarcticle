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
    it { should have_button('Post article') }

    describe "valid data" do
      before do
        fill_in_placeholder 'Article title', "article1 title"
        fill_in_placeholder 'Enter article content here ...', "Lorem ipsum"
      end

      it "should create an article" do
        expect { click_button "Post article" }.to change(Article, :count).by(1)
      end

      describe "created article" do
        before { click_button "Post article" }
        it { current_path.should == article_path(1) }
        #should have_selector('div.alert.alert-success', text: "Article was successfully created")
        it { should have_content("Article was successfully created") }
      end
    end

    describe "invalid data" do
      it "should not create an article" do
        expect { click_button "Post article" }.not_to change(Article, :count)
      end

      describe "errors" do
        before { click_button "Post article" }
        it { should have_error_message('Title') }
      end
    end
  end

  describe "article details" do
    let(:article) { FactoryGirl.create(:article, user: user) }
    before { visit article_path(article) }

    it { should have_content(article.title) }
    it { should have_content(article.content) }
    it { should have_link(user.username) }
    it { should have_content(I18n.l(article.created_at, :format => :long)) }
  end
end
