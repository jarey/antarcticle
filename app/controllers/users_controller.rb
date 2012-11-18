class UsersController < ApplicationController
  def show
    @user = get_user params[:username]
    @user_articles = get_users_articles(@user, params[:page])
    authorize! :read, @user
  end

  private
  def get_user(username)
    User.find_by_username(username)
  end

  def get_users_articles(user, page)
    user.articles.paginate(page: page, per_page: 10)
  end
end
