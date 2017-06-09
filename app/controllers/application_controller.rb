class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  
	include ApplicationHelper

	include ConfigurablesHelper

	before_action :init_configurable
	  
end
