class UsersController < ApplicationController
  def show
    @user = get_user params[:username]
    authorize! :read, @user

    tags = params[:tags]

    if tags.present? and not tags.blank?
      @user_articles = get_user_articles_tagged @user, params[:page], tags
    else
      @user_articles = get_user_articles @user, params[:page]
    end
  end

  private
  def get_user(username)
    User.find_by_username(username)
  end

  def get_user_articles(user, page)
    user.articles.includes(:user, :tags).paginate(page: page, per_page: 10)
  end

  def get_user_articles_tagged(user, page, tags)
    user
    .articles
    .includes(:user, :tags)
    .tagged_with(tags)
    .paginate(page: page, per_page: 10)
  end
end
