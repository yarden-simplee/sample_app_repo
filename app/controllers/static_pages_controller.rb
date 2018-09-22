class StaticPagesController < ApplicationController
	
  # For each action, the controller will perform the action
  # and then render the corresponding view by name.
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
