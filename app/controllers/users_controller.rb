class UsersController < ApplicationController

  # 'before_action' is called 'before_filter' in previous rails versions
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers] # Makes sure user is logged in before allowing it to perform sensitive action
  before_action :correct_user,   only: [:edit, :update] # Makes sure the user performing the action is the correct user
  before_action :admin_user,     only: :destroy # Make sure only admins can issue a user delete request

  def index
    @users = User.where(activated: true).paginate(page: params[:page]) # 'params[:page]' is generated automatically by 'will_paginate', which is used in the view
  end

  def show
  	@user = User.find(params[:id]) # The 'id' param is supplied in the url
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)   
    if @user.save 
    	@user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    
    # 'update_attributes' is a built-in rails function that accepts a has of values to update
    # and returns 'true' if it was successful
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private

  # Returns a version of the 'params' hash with only the specified parameters
  # If a parameter named 'user' is not present, an error is raised
  def user_params
  	params.require(:user).permit(:name, :email, :password,
  				   :password_confirmation)
  end

  # Before filters


  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
