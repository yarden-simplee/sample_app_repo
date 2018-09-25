class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		@user = User.find(params[:followed_id])
		current_user.follow(@user)
		respond_to do |format| # The 'respond_to' block is desgined to allow the controller to respond to Ajax requests
      		format.html { redirect_to @user }
      		format.js
    	end

    	# ** In the case of an Ajax request, Rails automatically calls a Javascript embedded Ruby
    	# (.js.erb) file with the same name as the action. In this case, 'views/relationships/create.js.erb'.
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow(@user)
		respond_to do |format| # The 'respond_to' block is desgined to allow the controller to respond to Ajax requests
      		format.html { redirect_to @user }
      		format.js
    	end

    	# ** In the case of an Ajax request, Rails automatically calls a Javascript embedded Ruby
    	# (.js.erb) file with the same name as the action. In this case, 'views/relationships/destroy.js.erb'.
	end

end
