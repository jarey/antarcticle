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
    it { should have_placeholder("Tags (separated by commas)") }
    it { should have_button('Post article') }

    describe "valid data" do
      before do
        fill_in_placeholder 'Article title', "article1 title"
        fill_in_placeholder 'Enter article content here ...', "Lorem ipsum"
        fill_in_placeholder 'Tags (separated by commas)', "tag1, tag2"
      end

      it "should create an article" do
        expect { click_button "Post article" }.to change(Article, :count).by(1)
      end

      describe "created article" do
        before { click_button "Post article" }
        it { current_path.should == article_path(1) }
        it { should have_selector('div.alert.alert-success', text: "Article was successfully created") }
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
    let(:article) { FactoryGirl.create(:article, user: user, tag_list: "tag1,tag2") }
    before { visit article_path(article) }

    it { should have_content(article.title) }
    it { should have_content(article.content) }
    it { should have_link(user.username) }
    it { should have_content(I18n.l(article.created_at, :format => :long)) }
    it "should have tags as links" do
      %w[tag1 tag2].each do |tag|
        should have_link(tag)
      end
    end
  end

  describe "article with markdown" do
    let(:article) { FactoryGirl.create(:article, user: user, content: "# Header") }
    before { visit article_path(article) }

    it { should have_selector('h1', text: "Header") }
  end

  describe "articles index" do
    before do
      FactoryGirl.create(:article, user: user, content: "Content1", title: "title1")
      FactoryGirl.create(:article, user: user, content: "Content2", title: "title2")
      visit articles_path
    end

    it "should render articles" do
      Article.all.each do |item|
        should have_selector("li##{item.id} h2", text: item.title)
        should have_selector("li##{item.id}", text: item.content)
        should have_selector("li##{item.id}", text: item.user.username)
        should have_selector("li##{item.id}", text: I18n.l(item.created_at, :format => :long))
      end
    end

    # TODO: test it for not signed in user
    it { should have_link('Write article') }

    it { should_not have_selector("#pagination") }
  end

  describe "pagination" do
    before do
      20.times do |n|
        FactoryGirl.create(:article, user: user, content: "Content#{n}", title: "title#{n}")
      end
      visit articles_path
    end

    it { should have_selector(".pagination") }
  end
end
