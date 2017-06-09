class Api::ApplicationController < ActionController::API
	# include DeviseTokenAuth::Concerns::User
	before_action :set_cookie_token

	include DeviseTokenAuth::Concerns::SetUserByToken

	include ApplicationHelper

	include ActionController::Cookies

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

	include ConfigurablesHelper

	before_action :init_configurable

	private

	def invalid_record error    	
	  render json: { errors: error }, status: 404
	end

	def set_cookie_token

		unless cookies[:visitor_token]

			cookies[:visitor_token] = generate_unique_secure_token			
			
		end
		
	end

end