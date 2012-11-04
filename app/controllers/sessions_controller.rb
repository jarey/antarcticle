class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_username(params[:session][:username])
    if user
      sign_in user
      redirect_back_or user
    else
      flash.now[:signin_error] = 'Incorrect Username or Password!'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
