class TagsController < ApplicationController
  def index
    authorize! :read, Article
    params[:tags] = CGI.unescape(params[:tags])
    @articles = Article.get_page_tagged params[:page], params[:tags]
    render 'articles/index'
  end

  def filter
    if params[:tags].blank?
      redirect_to articles_path
    else
      redirect_to tag_path(CGI.escape params[:tags])
    end
  end
end
