require 'spec_helper'

describe Comment do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  let(:article) { FactoryGirl.create(:article, user: user) }
  before { visit article_path(article) }


  describe "form" do
    context "when user is signed in" do
      before { sign_in user }
      it { should have_placeholder 'Enter your comment here ...' }
      it { should have_button 'Post' }

      context "submitted with valid data" do
        before do
          fill_in 'Enter your comment here ...', with: "My new comment"
        end

        it "creates new comment" do
          expect { click_button "Post" }.to change(Comment, :count).by(1)
        end

        it "redirects to comment" do
          click_button "Post"
          current_path.should == article_path(Article.last, anchor: "comment_#{Comment.last.id}")
        end
      end

      context "submitted with invalid data" do
        it "doesnt create comment" do
          expect { click_button "Post" }.not_to change(Comment, :count)
        end

        it "shows error" do
          click_button "Post"
          should have_error_message "Comment content can't be blank"
        end
      end
    end

    context "when user is not signed in" do
      it "form doesnt show"
    end
  end


  describe "list" do
    context "is not empty" do
      before do
       @comment = FactoryGirl.create(:comment, article: article)
       @comment_author = FactoryGirl.create(:comment, article: article, user: user)
       visit article_path(article)
      end

      it "shows comments" do
        should have_content @comment.content
        should have_content @comment_author.content
      end

      it "article author comments highlighted"

      #describe "comment details" do
        #context "as author"
        #context "as other user"
      #end
    end

    context "is empty" do
      it { should have_content "There is no comments" }
    end
  end
end
