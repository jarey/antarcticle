require 'spec_helper'

describe "Article" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "creation page" do
    before { visit new_article_path }

    describe "form elements" do
      it { should have_selector 'h2', text: "New article" }
      it { should have_placeholder 'Enter article content here ...' }
      it { should have_placeholder 'Article title' }
      it { should have_placeholder "Tags (separated by commas)" }
      it { should have_button 'Post article' }
    end

    context "submitted with valid data" do
      before do
        fill_in 'Article title', with: "article1 title"
        fill_in 'Enter article content here ...', with: "Lorem ipsum"
        fill_in 'Tags (separated by commas)', with: "tag1, tag2"
      end

      it "creates new article" do
        expect { click_button "Post article" }.to change(Article, :count).by(1)
      end

      describe "redirect" do
        before { click_button "Post article" }

        it "leads to articles details page" do
          current_path.should == article_path(Article.last)
        end

        it "shows success message" do
          should have_selector 'div.alert.alert-success', text: "Article was successfully created"
        end
      end
    end

    context "submitted with invalid data" do
      it "doesnt create article" do
        expect { click_button "Post article" }.not_to change(Article, :count)
      end

      describe "errors" do
        before { click_button "Post article" }
        it "shows error in title field" do
          should have_error_message 'Title'
        end
      end
    end
  end

  describe "edit" do
    let(:article) { FactoryGirl.create(:article, user: user, tag_list: "tag1,tag2") }
    before { visit edit_article_path(article) }

    describe "form" do
      it { should have_selector 'h2', text: "Editing article" }
      it { should have_button 'Edit article' }
      it { should have_placeholder 'Enter article content here ...', value: article.content }
      it { should have_placeholder 'Article title', value: article.title }
      it { should have_placeholder "Tags (separated by commas)", value: article.tag_list.to_s }
    end

    context "submitted" do
      it "doesnt create new article" do
        expect { click_button "Edit article" }.not_to change(Article, :count)
      end

      describe "redirect" do
        before { click_button "Edit article" }

        it "leads to article details page" do
          current_path.should == article_path(article)
        end

        it "shows success message" do
          should have_selector 'div.alert.alert-success', text: "Article was successfully updated"
        end
      end
    end
  end

  describe "details" do
    let(:article) { FactoryGirl.create(:article, user: user, tag_list: "tag1,tag2") }
    before { visit article_path(article) }

    it { should have_content article.title }
    it { should have_content article.content }
    it { should have_link user.username }
    it { should have_selector ".date" }

    it "shows tags as links" do
      %w[tag1 tag2].each do |tag|
        should have_link(tag)
      end
    end

    context "visited by author" do
      it { should have_link "Edit", href: edit_article_path(article) }
    end

    context "visited by other user" do
      before { sign_in FactoryGirl.create(:user) }
      it { should_not have_link "Edit", href: edit_article_path(article) }
    end

    context "content with markdown" do
      let(:article) { FactoryGirl.create(:article, user: user, content: "# Header") }
      before { visit article_path(article) }

      it "should be rendered" do
        should have_selector 'h1', text: "Header"
      end
    end
  end

  describe "index" do
    context "with articles" do
      before do
        FactoryGirl.create(:article,
                           user:     user,
                           content:  "Content1",
                           title:    "title1",
                           tag_list: "tag1,tag2")
        FactoryGirl.create(:article,
                           user:     user,
                           content:  "Content2",
                           title:    "title2",
                           tag_list: "tag1,tag2")
        visit articles_path
      end

      it "lists all articles" do
        Article.all.each do |item|
          should have_selector "article##{item.id} h2", text: item.title
          should have_selector "article##{item.id}", text: item.content
          should have_selector "article##{item.id}", text: item.user.username
          should have_selector "article##{item.id} .date"
        end
      end

      context "few articles" do
        it "doesnt display pagination" do
          should_not have_selector ".pagination"
        end
      end

      context "many articles" do
        before do
          20.times do |n|
            FactoryGirl.create(:article,
                               user:    user,
                               content: "Content#{n}",
                               title:   "title#{n}")
          end
          visit articles_path
        end

        it "displays pagination" do
          should have_selector ".pagination"
        end
      end
    end

    context "without articles" do
      it { should have_content "There is no articles" }
    end

    context "visited by registered user" do
      it { should have_link 'Write article' }
    end

    context "visited by guest" do
      before { sign_out }
      it { should_not have_link 'Write article' }
    end

    describe "tags filter" do
      before :each do
        fill_in 'tags_filter', with: "tag1,tag2"
        click_button "Find"
      end

      it "opens tags page" do
        current_path.should == tag_path("tag1,tag2")
      end
    end

  end

end
