class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # By including the following module here, it will be available for use in all the controllers
  include SessionsHelper # A sessions helper module that was generated automatically when generating the sessions controller.
end
