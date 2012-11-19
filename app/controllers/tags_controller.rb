class TagsController < ApplicationController
  def index
    @tags_names = get_tags_names params[:tags]
    @articles = get_articles_tagged_with(params[:tags], params[:page])
    authorize! :read, Article
  end

  def filter
    redirect_to tag_path(params[:tags])
  end

  private
  def get_tags_names(params_string)
    params_string.split(",").each { |t| t.strip }
  end

  def get_articles_tagged_with(tags, page)
    Article.tagged_with(tags).paginate(page: page, per_page: 10)
  end

end
