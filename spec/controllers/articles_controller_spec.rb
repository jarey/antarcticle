require 'spec_helper'

describe ArticlesController do

  def attributes
    { "title" => "title", "content" => "content" }
  end

  let(:article) { mock_model('Article') }
  let(:current_user) { mock_model('User') }
  let(:article_id) { article.to_param }

  before  do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @ability.stub(:can?).and_return(true)
    controller.stub(:current_ability).and_return(@ability)
  end

  describe "#update" do

    before do
      Article.should_receive(:find).with(article_id).and_return(article)
      controller.should_receive(:authorize!).with(:update, article)
    end

    context "when attributes are valid" do
      before do
        article.should_receive(:update_attributes).and_return(true)
      end

      it "redirects to article" do
        put :update, id: article_id
        should redirect_to(article)
      end

      it "contains notice" do
        put :update, id: article_id
        flash[:notice].should_not be_blank
      end
    end

    context "when attributes are not valid" do
      before do
        article.should_receive(:update_attributes).and_return(false)
      end

      it "re-renders edit method" do
        put :update, id: article_id
        should render_template(:edit)
      end
    end
  end

  describe "#create" do
    let(:articles) { mock('articles') }

    before do
      controller.should_receive(:authorize!).with(:create, Article)
      controller.stub(:current_user).and_return(current_user)
      current_user.should_receive(:articles).and_return(articles)
      articles.should_receive(:build).with(attributes).and_return(article)
    end

    context "when attributes are valid" do
      before do
        article.should_receive(:save).and_return(true)
      end

      it "redirects to article" do
        post :create, article: attributes
        should redirect_to(article)
      end

      it "contains notice" do
        post :create, article: attributes
        flash[:notice].should_not be_blank
      end
    end

    context "when attributes are not valid" do
      before  do
        article.should_receive(:save).and_return(false)
      end

      it "re-renders new method " do
        post :create, article: attributes
        should render_template(:new)
      end
    end
  end

  describe "#show" do
    before do
      Article.should_receive(:find).with(article_id).and_return(article)
      controller.should_receive(:authorize!).with(:read, article)
    end

    it "assigns article" do
      get :show, id: article_id
      assigns(:article).should be article
    end
  end

  describe "#destroy" do
    before do
      Article.should_receive(:find).with(article_id).and_return(article)
      controller.should_receive(:authorize!).with(:destroy, article)
      article.should_receive(:destroy)
    end

    it "redirects to articles index" do
      delete :destroy, id: article_id
      should redirect_to(articles_url)
    end
  end

  describe "#edit" do
    before do
      Article.should_receive(:find).with(article_id).and_return(article)
      controller.should_receive(:authorize!).with(:update, article)
    end

    it "assigns article" do
      get :edit, id: article_id
      assigns(:article).should be article
    end
  end

  describe "#new" do
    let(:new_article) { mock('article') }

    before do
      controller.should_receive(:authorize!).with(:create, Article)
      Article.should_receive(:new).and_return(new_article)
    end

    it "assigns article" do
      get :new
      assigns(:article).should be new_article
    end
  end

  describe "#index" do
    let(:articles) { mock('articles') }
    let(:page) { "1" }

    before do
      controller.should_receive(:authorize!).with(:read, Article)
      Article.should_receive(:get_page).with(page).and_return(articles)
    end

    it "assigns articles" do
      get :index, { page: page }
      assigns(:articles).should be_present
    end
  end
end
