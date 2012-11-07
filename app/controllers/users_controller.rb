class UsersController < ApplicationController
  def show
    @user = User.find_by_username(params[:username])
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 10)
  end
end
