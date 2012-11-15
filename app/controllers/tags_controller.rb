class TagsController < ApplicationController
  def index
    @tag = Tag.find_by_name!(params[:tag])
    @articles = Article.tagged_with(@tag.name).paginate(page: params[:page], per_page: 10)
    authorize! :read, Tag
  end
end
