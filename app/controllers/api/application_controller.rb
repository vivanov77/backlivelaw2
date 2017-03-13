class Api::ApplicationController < ActionController::API
	# include DeviseTokenAuth::Concerns::User
	include DeviseTokenAuth::Concerns::SetUserByToken

	include ApplicationHelper

	rescue_from ActiveRecord::RecordNotFound, with: :invalid_record

	include CanCan::ControllerAdditions

	rescue_from CanCan::AccessDenied do |exception|
		if current_user.has_role? :blocked
			sign_out
			error_message = "Пользователь заблокирован."
		else
			error_message = "У Вас нет роли на #{ru_action exception.action}."
		end

        render json: { errors: error_message }, status: :unprocessable_entity		
	end

	private

	def invalid_record error    	
	  render json: { errors: error }, status: 404
	end

end