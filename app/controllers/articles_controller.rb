class ArticlesController < ApplicationController

  def index
    @articles = Article.paginate(page: params[:page], per_page: 10)
    authorize! :read, Article
  end

  def show
    @article = Article.find(params[:id])
    authorize! :read, @article
  end

  def new
    @article = Article.new
    authorize! :create, Article
  end

  def edit
    @article = Article.find(params[:id])
    authorize! :update, @article
  end

  def create
    @article = current_user.articles.build(params[:article])
    authorize! :create, Article

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
