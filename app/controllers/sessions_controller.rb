class SessionsController < ApplicationController
  include AppHelpers::Cart
  def new
  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to home_path, notice: "Logged in!"
      if user.role?(:admin) || user.role?(:parent)
        create_cart
      end
    else
      flash.now.alert = "Username and/or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    destroy_cart
    redirect_to home_path, notice: "Logged out!"
  end
end