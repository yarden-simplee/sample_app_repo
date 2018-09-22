class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # By including the following module here, it will be available for use in all the controllers
  include SessionsHelper # A sessions helper module that was generated automatically when generating the sessions controller.

  # In ruby, private methods can be used in derived classes as well
  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
end
