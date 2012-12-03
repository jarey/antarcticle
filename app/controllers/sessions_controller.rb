require 'authentication_service'

class SessionsController < ApplicationController
  def new
  end

  def create
    if CONFIG["poulpe_authentication"]
      user = AuthenticationService.authenticate(params[:session][:username], params[:session][:password])
    else
      user = User.find_by_username(params[:session][:username])
    end
    if user
      sign_in user
      flash[:notice] = 'You have successfully signed in!'
      redirect_back_or root_path
    else
      flash.now[:signin_error] = 'Incorrect Username or Password!'
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:info] = 'You are now signed out'
    redirect_to root_url
  end
end
