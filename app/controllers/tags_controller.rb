class TagsController < ApplicationController
  def index
    authorize! :read, Article
    @articles = Article.get_page_tagged params[:page], params[:tags]
    render 'articles/index'
  end

  def filter
    if params[:tags].blank?
      redirect_to articles_path
    else
      redirect_to tag_path(params[:tags].gsub('/', '%2F'))
    end
  end
end
