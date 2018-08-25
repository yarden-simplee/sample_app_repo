class SessionsController < ApplicationController

  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
    	log_in @user # 'log_in' defined in the 'sessions_helper'
    	# When using the ternary operator in ruby, functions who accept arguments must use parentheses (see 'remember' and 'forget' below)
    	params[:session][:remember_me] == '1' ? remember(@user) : forget(@user) # 'remember' and 'forget' also defined in sessions helper
    	redirect_to @user # Is automatically converted bvy rails to the route for user's profile page - user_url(user)
    else
    	flash.now[:danger] = 'Invalid email/password combination' # 'flash.now' instead of just 'flash' because 'flash' to prevent 'flash persistence'*
  		render 'new'
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_url
  end

end


# 'Flash Persistence' - by design, flash persists for one request.
# the 'render' command is not considered a request, 
# as opposed to 'redirect'. Hence, the flash message would linger for an additional refresh/routing.
# To avoid this, we use 'flash.now'.