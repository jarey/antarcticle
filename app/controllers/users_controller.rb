class UsersController < ApplicationController
  def show
    @user = get_user params[:username]
    authorize! :read, @user

    tags = params[:tags]

    if tags.present? and not tags.blank?
      @user_articles = @user.articles.get_page_tagged params[:page], tags
    else
      @user_articles = @user.articles.get_page params[:page]
    end
  end

  private
  def get_user(username)
    User.find_by_username(username)
  end
end
