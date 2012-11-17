class TagsController < ApplicationController
  def index
    @tags_names = params[:tags].split(",").each { |t| t.strip }
    @articles = Article.tagged_with(params[:tags]).paginate(page: params[:page], per_page: 10)
    authorize! :read, Article
  end

end
