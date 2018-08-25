class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id]) # The 'id' param is supplied in the url
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)   
    if @user.save 
    	log_in @user

      flash[:success] = "Welcome to the Sample App!" # For later disdplay of a temp message in case of success
      redirect_to @user # Equivalent to 'redirect_to user_url(@user)'. Rails automatically infers the latter from the former
    else
      render 'new'
    end
  end


  private

  # Returns a version of the 'params' hash with only the specified parameters
  # If a oarameter named 'user' is not present, an error is raised
  def user_params
  	params.require(:user).permit(:name, :email, :password,
  				   :password_confirmation)
  end

end
