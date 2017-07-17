class Admin::ApplicationController < ApplicationController
	protect_from_forgery with: :exception

	before_action :authenticate_user!
	load_and_authorize_resource

	rescue_from CanCan::AccessDenied do |exception|
		if current_user.has_role? :blocked
			sign_out
			redirect_to store_path, notice: "Пользователь заблокирован."
		else
			redirect_back(fallback_location: root_path, notice:    
			#"You don't have the right to #{exception.action} #{exception.subject.class.to_s.downcase.pluralize}"
			# "You don't have the right to #{exception.action} #{exception.subject.class.to_s.downcase == 'class' ? exception.subject.to_s.pluralize : exception.subject.class.to_s}"
			"У Вас нет роли на #{ru_action exception.action}.")
			#"You don't have the right to #{exception.action} #{exception.subject.class}"
		end
	end

	rescue_from ActiveRecord::DeleteRestrictionError do |exception|
			redirect_to :back, notice:
			"#{exception.message}."
	end

	rescue_from UserError do |exception|
			redirect_to :back, notice:
			"#{exception.message}"
	end	
end