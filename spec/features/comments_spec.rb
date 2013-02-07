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
        before do
          find('#comments_form').fill_in 'Enter your comment here ...', with: "My new comment"
        end

        it "creates new comment" do
          expect { find('#comments_form').click_button "Post" }.to change(Comment, :count).by(1)
        end

        it "opens article page" do
          find('#comments_form').click_button "Post"
          #TODO current_path.should == article_path(article, anchor: "comment_#{Comment.last.id}")
          current_path.should == article_path(article)
        end
      end

      context "submitted with invalid data" do
        let(:long_text) { "a" * 3050 }
        before { find('#comments_form').fill_in 'Enter your comment here ...', with: long_text }

        it "doesnt create comment" do
          expect { find('#comments_form').click_button "Post" }.not_to change(Comment, :count)
        end

        it "opens article page" do
          find('#comments_form').click_button "Post"
          #TODO current_path.should == article_comments_path(article, anchor: "comments_form")
          current_path.should == article_comments_path(article)
        end

        it "fills form with data" do
          find('#comments_form').click_button "Post"
          find('#comments').should have_placeholder 'Enter your comment here ...', value: long_text
        end

        it "shows error"# do
          #click_button "Post"
          #should have_error_message "Comment content can't be blank"
        #end
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
    end

    context "is empty" do
      before { visit article_path(article) }
      it { find('#comments').should have_content "There is no comments" }
    end
  end
end
