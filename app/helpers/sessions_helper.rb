module SessionsHelper

	# Logs in the given user.
	def log_in(user)
		session[:user_id] = user.id # The 'session' method creates temporary cookies which are destroyed when the browser closes. All the information generated using this method is encrypted
	end

	# Remembers a user in a presistent session
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# Returns true if the given user is the current user
	def current_user?(user)
		user == current_user
	end

	# Returns the user coprresponding to the remember token cookie
	def current_user
		# The following is actually an assignment and not a comparison
		# If 'session[:user_id]' exists, assign it into user_id and perform the following
		if (user_id = session[:user_id])
      		@current_user ||= User.find_by(id: user_id)
    	elsif (user_id = cookies.signed[:user_id])
      		user = User.find_by(id: user_id)

      		if user && user.authenticated?(cookies[:remember_token])
        		log_in user
        		@current_user = user
      		end
    	end
	end

	# Returns true if the user is logged in, false otherwise
	def logged_in?
		!current_user.nil?
	end

	# Forgets a persistent session
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	# Logs out thew current user
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	# Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    # The following deletion happens even though the redirect stastement is written first.
    # This is because the redirect doesn't actually happen until an explicit
    # return statement or until the end of a method.
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
