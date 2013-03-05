require 'spec_helper'

describe CommentsController do
  let(:attributes) { { "content" => "content" } }
  let(:article) {  mock_model(Article).as_null_object  }
  let(:article_id) { article.to_param }
  let(:comment) { mock_model(Comment).as_null_object }
  let(:comment_id) { comment.to_param }

  before do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @ability.stub(:can?).and_return(true)
    controller.stub(:current_ability).and_return(@ability)
    Comment.stub(:find).with(comment_id).and_return(comment)
  end

  describe "#update" do
    it "authorizes update" do
      controller.should_receive(:authorize!).with(:update, comment)
      put :update, article_id: article_id, id: comment_id, comment: attributes
    end

    it "tries to update comment" do
      comment.should_receive(:update_attributes)
      put :update, article_id: article_id, id: comment_id, comment: attributes
    end

    context "when attrs are valid" do
      before { put :update, article_id: article_id, id: comment_id, comment: attributes }

      it "redirects to updated comment on article page" do
        should redirect_to(article_path(article_id, anchor: "comment_#{comment.id}"))
      end
    end

    context "when attrs are invalid" do
      before do
        Article.stub(:find).with(article_id).and_return(article)
        comment.stub(:update_attributes).and_return(false)
        put :update, article_id: article_id, id: comment_id, comment: attributes
      end

      it "assigns article" do
        assigns(:article).should be article
      end

      it "re-renders template" do
        should render_template('articles/show')
      end
    end
  end

  describe "#edit" do
    before do
      Article.stub(:find).with(article_id).and_return(article)
    end

    it "authorizes update" do
      controller.should_receive(:authorize!).with(:update, comment)
      get :edit, article_id: article_id, id: comment_id
    end

    it "assigns article" do
      get :edit, article_id: article_id, id: comment_id
      assigns(:article).should be article
    end

    it "assigns comment" do
      get :edit, article_id: article_id, id: comment_id
      assigns(:comment_to_edit).should be comment
    end

    it "shows article page" do
      get :edit, article_id: article_id, id: comment_id
      should render_template('articles/show')
    end
  end

  describe "#create" do
    let(:current_user) { mock_model(User) }

    before do
      controller.stub(:current_user).and_return(current_user)
      Article.stub(:find).with(article_id).and_return(article)
      Comment.stub(:new).with(attributes).and_return(comment)
    end

    it "creates new article with attrs" do
      Comment.should_receive(:new).with(attributes)
      post :create, article_id: article_id, comment: attributes
    end

    it "authorizes creation" do
      controller.should_receive(:authorize!).with(:create, Comment)
      post :create, article_id: article_id, comment: attributes
    end

    it "creates new comment as current user" do
      comment.should_receive(:user=).with(current_user)
      post :create, article_id: article_id, comment: attributes
    end

    it "creates new comment for given article" do
      comment.should_receive(:article=).with(article)
      post :create, article_id: article_id, comment: attributes
    end

    it "tries to save created comment" do
      comment.should_receive(:save)
      post :create, article_id: article_id, comment: attributes
    end

    it "assigns article" do
      post :create, article_id: article_id, comment: attributes
      assigns(:article).should be article
    end

    context "when attrs are valid" do
      before { post :create, article_id: article_id, comment: attributes }

      it "redirects to created comment on article page" do
        should redirect_to(article_path(article_id, anchor: "comment_#{comment.id}"))
      end
    end

    context "when attrs are invalid" do
      before do
        comment.stub(:save).and_return(false)
        post :create, article_id: article_id, comment: attributes
      end

      it "re-renders template" do
        should render_template('articles/show')
      end
    end
  end

  describe "#destroy" do
    it "authorizes destroy" do
      controller.should_receive(:authorize!).with(:destroy, comment)
      delete :destroy, article_id: article_id, id: comment_id
    end

    it "destroys comment" do
      comment.should_receive(:destroy)
      delete :destroy, article_id: article_id, id: comment_id
    end

    it "redirects to article comments" do
      delete :destroy, article_id: article_id, id: comment_id
      should redirect_to(article_path(article_id, anchor: "comments"))
    end
  end
end
