require 'spec_helper'

describe ArticlesController do

  let(:attributes) { { "title" => "title", "content" => "content" } }
  let(:article) { mock_model(Article).as_null_object }
  let(:article_id) { article.to_param }

  before  do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @ability.stub(:can?).and_return(true)
    controller.stub(:current_ability).and_return(@ability)
    Article.stub(:find).with(article_id).and_return(article)
  end

  describe "#update" do
    it "authorizes update" do
      controller.should_receive(:authorize!).with(:update, article)
      put :update, id: article_id, article: attributes
    end

    it "tries to update article" do
      article.should_receive(:update_attributes).with(attributes)
      put :update, id: article_id, article: attributes
    end

    context "when attributes are valid" do
      before { put :update, id: article_id, article: attributes }

      it "redirects to article" do
        should redirect_to(article)
      end

      it "sets notice" do
        flash[:notice].should_not be_blank
      end
    end

    context "when attributes are not valid" do
      before do
        article.stub(:update_attributes).and_return(false)
        put :update, id: article_id
      end

      it "re-renders edit method" do
        should render_template(:edit)
      end
    end
  end

  describe "#create" do
    let(:articles) { mock('articles') }
    let(:current_user) { mock_model(User) }

    before do
      controller.stub(:current_user).and_return(current_user)
      current_user.stub(:articles).and_return(articles)
      articles.stub(:build).with(attributes).and_return(article)
    end

    it "authorizes creation" do
      controller.should_receive(:authorize!).with(:create, Article)
      post :create, article: attributes
    end

    it "creates new article as current user" do
      current_user.should_receive(:articles).and_return(articles)
      articles.should_receive(:build).with(attributes).and_return(article)
      post :create, article: attributes
    end

    it "tries to save created article" do
      article.should_receive(:save)
      post :create, article: attributes
    end

    context "when attributes are valid" do
      before { post :create, article: attributes }

      it "redirects to article" do
        should redirect_to(article)
      end

      it "sets notice message" do
        flash[:notice].should_not be_blank
      end
    end

    context "when attributes are not valid" do
      before  do
        article.stub(:save).and_return(false)
        post :create, article: attributes
      end

      it "re-renders new method " do
        should render_template(:new)
      end
    end
  end

  describe "#show" do
    it "authorizes show" do
      controller.should_receive(:authorize!).with(:read, article)
      get :show, id: article_id
    end

    it "assigns @article" do
      get :show, id: article_id
      assigns(:article).should be article
    end
  end

  describe "#destroy" do
    it "destroys article" do
      article.should_receive(:destroy)
      delete :destroy, id: article_id
    end

    it "authorizes destroy" do
      controller.should_receive(:authorize!).with(:destroy, article)
      delete :destroy, id: article_id
    end

    it "redirects to articles index" do
      delete :destroy, id: article_id
      should redirect_to(articles_url)
    end
  end

  describe "#edit" do
    it "authorizes edit" do
      controller.should_receive(:authorize!).with(:update, article)
      get :edit, id: article_id
    end

    it "assigns @article" do
      get :edit, id: article_id
      assigns(:article).should be article
    end
  end

  describe "#new" do
    let(:new_article) { mock('article') }

    before do
      Article.stub(:new).and_return(new_article)
    end

    it "authorizes new" do
      controller.should_receive(:authorize!).with(:create, Article)
      get :new
    end

    it "creates new article" do
      Article.should_receive(:new).with(no_args)
      get :new
    end

    it "assigns @article" do
      get :new
      assigns(:article).should be new_article
    end
  end

  describe "#index" do
    let(:articles) { mock('articles') }
    let(:page) { "1" }

    before do
      Article.stub(:get_page).and_return(articles)
    end

    it "reads paginated result" do
      Article.should_receive(:get_page).with(page)
      get :index, { page: page }
    end

    it "authorizes read" do
      controller.should_receive(:authorize!).with(:read, Article)
      get :index, { page: page }
    end

    it "assigns articles" do
      get :index, { page: page }
      assigns(:articles).should be_present
    end
  end
end
