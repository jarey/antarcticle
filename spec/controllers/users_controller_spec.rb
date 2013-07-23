require 'spec_helper'

describe UsersController do

  let(:user) { mock_model(User).as_null_object }
  let(:username) { "user1" }

  describe "#show" do
    let(:articles) { double('articles').as_null_object }
    let(:page) { "1" }

    before do
      User.stub(:find_by_username).and_return(user)
      user.stub(:articles).and_return(articles)
    end

    it "fetches user from db" do
      User.should_receive(:find_by_username).with(username)
      get :show, { username: username, page: page }
    end

    it "authorizes read" do
      controller.should_receive(:authorize!).with(:read, user)
      get :show, { username: username, page: page }
    end

    it "assigns @user" do
      get :show, { username: username, page: page }
      assigns(:user).should be user
    end

    context "with tags" do
      let(:tags) { "tag1,tag2" }

      before do
        articles.stub(:get_page_tagged).and_return(articles)
      end

      it "fetches tagged articles" do
        articles.should_receive(:get_page_tagged).with(page, tags)
        get :show, { username: username, page: page, tags: tags }
      end

      it "assigns tagged articles to @user_articles" do
        get :show, { username: username, page: page, tags: tags }
        assigns(:user_articles).should be articles
      end
    end

    shared_examples "without tags" do
      before do
        articles.stub(:get_page).and_return(articles)
      end

      it "fetches all articles" do
        articles.should_receive(:get_page).with(page)
        get :show, { username: username, page: page, tags: tags }
      end

      it "assigns all articles to @user_articles" do
        get :show, { username: username, page: page, tags: tags }
        assigns(:user_articles).should be articles
      end
    end

    context "without tags specified" do
      it_behaves_like "without tags" do
        let(:tags) { nil }
      end
    end

    context "with blank tags" do
      it_behaves_like "without tags" do
        let(:tags) { "   " }
      end
    end
  end

end
