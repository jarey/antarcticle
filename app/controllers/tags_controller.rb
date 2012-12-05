class TagsController < ApplicationController
  def index
    authorize! :read, Article
    @articles = get_articles_tagged_with params[:tags], params[:page]
    render 'articles/index'
  end

  def filter
    if params[:tags].blank?
      redirect_to articles_path
    else
      redirect_to tag_path(params[:tags])
    end
  end

  private
  def get_articles_tagged_with(tags, page)
    Article.tagged_with(tags)
            .includes(:user, :tags)
            .paginate(page: page, per_page: 10)
  end

end
