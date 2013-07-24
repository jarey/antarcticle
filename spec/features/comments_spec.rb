require 'spec_helper'

describe Comment do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  let(:article) { FactoryGirl.create(:article, user: user) }

  describe "form" do
    context "when user is signed in" do
      before do
        sign_in user
        visit article_path(article)
      end

      it { find('#comments').should have_css('#comments_form') }
      it { find('#comments_form').should have_placeholder 'Enter your comment here ...' }
      it { find('#comments_form').should have_button 'Post' }

      context "submitted with valid data" do
        let(:new_comment_content) { "My new comment" }
        before do
          find('#comments_form').fill_in 'Enter your comment here ...', with: new_comment_content
        end

        it "creates new comment" do
          find('#comments_form').click_button "Post"
          find('#comments').should have_content new_comment_content
        end

        it "opens article page" do
          find('#comments_form').click_button "Post"
          current_path.should == article_path(article)
        end
      end

      context "submitted with invalid data" do
        let(:empty_string) { "" }
        before { find('#comments_form').fill_in 'Enter your comment here ...', with: empty_string }

        it "doesnt create comment" do
          expect { find('#comments_form').click_button "Post" }.not_to change(Comment, :count)
        end

        it "opens article page" do
          find('#comments_form').click_button "Post"
          current_path.should == article_comments_path(article)
        end

        it "fills form with data" do
          find('#comments_form').click_button "Post"
          find('#comments').should have_placeholder 'Enter your comment here ...', value: empty_string
        end

        it "shows error" do
          click_button "Post"
          should have_error_message "Content can't be blank"
        end
      end
    end

    context "when user is not signed in" do
      before { visit article_path(article) }
      it "form doesnt show" do
        should_not have_css('#comments_form')
      end
      it { find('#comments').should have_content "Sign in to post comments"}
    end
  end


  describe "list" do
    context "is not empty" do
      before do
       @comment = FactoryGirl.create(:comment, article: article)
       @comment_author = FactoryGirl.create(:comment, article: article, user: user)
       @comments = [@comment, @comment_author]
       visit article_path(article)
      end

      it "shows comments details" do
        @comments.each do |comment|
          find("#comments #comment_#{comment.id}").should have_content comment.user.username
          find("#comments #comment_#{comment.id}").should have_css('time')
          find("#comments #comment_#{comment.id}").should have_content comment.content
        end
      end

      it "article author comments highlighted" do
        #TODO check this is exactly author's comment
        find('#comments').should have_css('.comment-author', count: 1)
      end

      describe "signed in user actions"
    end

    context "is empty" do
      before { visit article_path(article) }
      it { find('#comments').should have_content "There is no comments" }
    end
  end

  describe "edit" do
    before do
      @comment = FactoryGirl.create(:comment, article: article, user: user)
      sign_in user
      visit article_path(article)
      find("#comment_#{@comment.id}").find('.edit-comment-btn').click
    end

    describe "page" do
      it "redirects to edit page" do
        current_path.should == edit_article_comment_path(article, @comment)
      end

      it { find('#comments').should have_css('#comments_form') }
      it { find('#comments_form').should have_placeholder 'Enter your comment here ...', value: @comment.content }
    end

    describe "submitted" do
      let(:new_content) { "My new comment" }
      before do
        @old_content = @comment.content
        find('#comments_form').fill_in 'Enter your comment here ...', with: new_content
        find('#comments_form').click_button "Post"
      end

      it "redirects back to article" do
        current_path.should == article_path(article)
      end

      it "should not have old content" do
        find('#comments').should_not have_content @old_content
      end

      it "should have new post content" do
        find('#comments').should have_content new_content
      end
    end

  end

  #TODO: web driver with JavaScript support required
  # describe "delete" do
  #   before do
  #     sign_in user
  #     @comment = FactoryGirl.create(:comment, article: article, user: user)
  #     visit article_path(article)
  #     find("#comment_#{@comment.id}").find(".icon-remove").click
  #   end

  #   it "should reload article page" do
  #     current_path.should == article_path(article)
  #   end

  #   it "should not contain removed comment" do
  #     find("#comments").should_not have_content @comment.content
  #   end

  #
  #   # it "should show confirmation dialog" do
  #   #   page.driver.browser.switch_to.alert.should_not be nil
  #   # end
  # end
end
