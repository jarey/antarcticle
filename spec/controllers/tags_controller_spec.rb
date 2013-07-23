require 'spec_helper'

describe TagsController do
  describe "#index" do
    let(:tags) { "tag1,tag2" }
    let(:page) { "1" }

    before do
      Article.stub(:get_page_tagged).and_return(double('articles'))
    end

    it "authorizes read" do
      controller.should_receive(:authorize!).with(:read, Article)
      get :index, { tags: tags, page: page }
    end

    it "fetches tagged articles" do
      Article.should_receive(:get_page_tagged).with(page, tags)
      get :index, { tags: tags, page: page }
    end

    it "renders articles index" do
      get :index, { tags: tags, page: page }
      should render_template('articles/index')
    end
  end

  describe "#filter" do
    context "with tags" do
      let(:tags) { "tag1,tag2" }

      it "redirects to tags index" do
        post :filter, { tags: tags }
        should redirect_to(tag_path(tags))
      end
    end

    context "with blank tags" do
      it "redirects to articles index" do
        post :filter, { tags: "   " }
        should redirect_to(articles_path)
      end
    end
  end
end
