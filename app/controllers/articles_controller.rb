class ArticlesController < ApplicationController

  def index
    authorize! :read, Article
    @articles = Article.get_page params[:page]
  end

  def show
    @article = Article.find(params[:id])
    authorize! :read, @article
    @comment = Comment.new
  end

  def new
    authorize! :create, Article
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
    authorize! :update, @article
  end

  def create
    authorize! :create, Article
    @article = current_user.articles.build(params[:article])

    if @article.save
      redirect_to @article, only_path: true, notice: 'Article was successfully created.'
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])
    authorize! :update, @article

    if @article.update_attributes(params[:article])
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    authorize! :destroy, @article
    @article.destroy

    redirect_to articles_url
  end
end
