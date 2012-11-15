require 'spec_helper'

describe "Article" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "creation" do
    before { visit new_article_path }

    describe "form" do
      it { should have_selector('h2', text: "New article") }
      it { should have_placeholder('Enter article content here ...') }
      it { should have_placeholder('Article title') }
      it { should have_placeholder("Tags (separated by commas)") }
      it { should have_button('Post article') }
    end

    context "submitted with valid data" do
      before do
        fill_in_placeholder 'Article title', "article1 title"
        fill_in_placeholder 'Enter article content here ...', "Lorem ipsum"
        fill_in_placeholder 'Tags (separated by commas)', "tag1, tag2"
      end

      it "should create new article" do
        expect { click_button "Post article" }.to change(Article, :count).by(1)
      end

      describe "redirect" do
        before { click_button "Post article" }

        it "should be on article details page" do
          current_path.should == article_path(1) 
        end

        it "should have success message" do
          should have_selector('div.alert.alert-success', text: "Article was successfully created")
        end
      end
    end

    context "submitted with invalid data" do
      it "should not create an article" do
        expect { click_button "Post article" }.not_to change(Article, :count)
      end

      describe "errors" do
        before { click_button "Post article" }
        it "should have error in title" do
          should have_error_message('Title')
        end
      end
    end
  end

  describe "editing" do
    let(:article) { FactoryGirl.create(:article, user: user, tag_list: "tag1,tag2") }
    before { visit edit_article_path(article) }

    describe "form" do
      it { should have_selector('h2', text: "Editing article") }
      it { should have_button('Edit article') }
      it "should have fields filled with article data" do
        should have_placeholder('Enter article content here ...', text: article.content)
        should have_placeholder('Article title', value: article.title)
        should have_placeholder("Tags (separated by commas)", value: article.tag_list)
      end
    end

    context "submitted" do
      it "new article should not be created" do
        expect { click_button "Edit article" }.not_to change(Article, :count)
      end

      describe "redirect" do
        before { click_button "Edit article" }

        it "should be on article details page" do
          current_path.should == article_path(1) 
        end

        it "should have success message" do
          should have_selector('div.alert.alert-success', text: "Article was successfully updated")
        end
      end
    end
  end

  describe "details" do
    let(:article) { FactoryGirl.create(:article, user: user, tag_list: "tag1,tag2") }
    before { visit article_path(article) }

    it "should contain aricle data" do
      should have_content(article.title)
      should have_content(article.content)
      should have_link(user.username)
      should have_content(I18n.l(article.created_at, :format => :long))
    end

    it "should have tags as links" do
      %w[tag1 tag2].each do |tag|
        should have_link(tag)
      end
    end

    context "visited by author" do
      it { should have_link("Edit", href: edit_article_path(article)) }
    end

    context "visited by other user" do
      before { sign_in FactoryGirl.create(:user) }
      it { should_not have_link("Edit", href: edit_article_path(article)) }
    end

    context "content with markdown" do
      let(:article) { FactoryGirl.create(:article, user: user, content: "# Header") }
      before { visit article_path(article) }

      it "should be rendered" do
        should have_selector('h1', text: "Header")
      end
    end
  end

  describe "index" do
    before do
      FactoryGirl.create(:article, user: user, content: "Content1", title: "title1")
      FactoryGirl.create(:article, user: user, content: "Content2", title: "title2")
      visit articles_path
    end

    it "should list all articles" do
      Article.all.each do |item|
        should have_selector("li##{item.id} h2", text: item.title)
        should have_selector("li##{item.id}", text: item.content)
        should have_selector("li##{item.id}", text: item.user.username)
        should have_selector("li##{item.id}", text: I18n.l(item.created_at, :format => :long))
      end
    end

    context "visited by registered user" do
      it { should have_link('Write article') }
    end

    context "visited by guest" do
      before { sign_out }
      it { should_not have_link('Write article') }
    end

    context "with few articles" do
      it "should not be paginated" do
        should_not have_selector(".pagination")
      end
    end

    context "with many articles" do
      before do
        20.times do |n|
          FactoryGirl.create(:article, user: user, content: "Content#{n}", title: "title#{n}")
        end
        visit articles_path
      end

      it "should be paginated" do
        should have_selector(".pagination")
      end
    end
  end

end
