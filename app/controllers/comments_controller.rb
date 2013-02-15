class CommentsController < ApplicationController
  def create
    authorize! :create, Comment
    @article = Article.find(params[:article_id])
    @comment = Comment.new(params[:comment])
    @comment.article = @article
    @comment.user = current_user
    if @comment.save
      redirect_to article_path(@article, anchor: "comment_#{@comment.id}")
    else
      #redirect_to article_path(@article, anchor: "comments")
      render 'articles/show'
    end
  end

  def update
    @comment = Comment.find(params[:id])
    authorize! :update, @comment

    if @comment.update_attributes(params[:comment])
      redirect_to article_path(params[:article_id], anchor: "comment_#{@comment.id}")
    else
      render 'articles/show'
    end
  end

  def edit
  #TODO
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize! :destroy, @comment
    @comment.destroy

    redirect_to article_path(params[:article_id], anchor: "comments")
  end
end
