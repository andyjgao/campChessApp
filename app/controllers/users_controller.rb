class UsersController < ApplicationController
  include AppHelpers::Cart
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_login, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    # finding all the active owners and paginating that list (will_paginate)
    @users = User.all.paginate(page: params[:page]).per_page(15)
  end

  def new
    @user = User.new
  end

  def edit
    @user.role = "assistant" if current_user.role?(:assistant)
  end

  def create
    @user = User.new(user_params)
    @user.role = "parent" if !logged_in?
    if @user.save!
      @family = Family.create(user_id: @user.id, family_name: params[:user][:family_name], parent_first_name: params[:user][:parent_first_name])
      @family.save!
      if !logged_in?
        session[:user_id] = @user.id

        create_cart
        redirect_to home_path, notice: "Welcome, #{@user.family.parent_first_name}. Thank you for signing up!"
      else
        redirect_to user_path(@user), notice: "Successfully created #{@user.proper_name}."
      end
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated #{@user.proper_name}."
      redirect_to users_url
    else
      render action: 'edit'
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_url, notice: "Successfully removed #{@user.proper_name} from the PATS system."
    else
      render action: 'show'
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      if current_user && current_user.role = "admin"
        params.require(:user).permit(:first_name, :last_name, :active, :username, :role, :password, :password_confirmation)
      else
        params.require(:user).permit(:first_name, :last_name, :username, :password, :password_confirmation, :family_name, :parent_first_name, :phone, :email, :role)
      end
    end

end