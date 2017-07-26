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

	rescue_from UserError do |exception|

        render json: { errors: exception.message }, status: :unprocessable_entity
	end	

	def register_login_tokenized_user email, password

        @user = User.find_or_create_by(email: email) { |u| u.password = password}
        @user.add_role :client

        @user.save!

        @client_id = SecureRandom.urlsafe_base64(nil, false)
        @token     = SecureRandom.urlsafe_base64(nil, false)

        @user.tokens[@client_id] = {
          token: BCrypt::Password.create(@token),
          expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
        }
        @user.save

        # @user.send_confirmation_instructions

        # @resource = @user # trade-off for "update_auth_header" defined in "DeviseTokenAuth::Concerns::SetUserByToken"

        # sign_in(:user, @user, store: false, bypass: false)

	end


    def check_captcha

      grecaptcha = params["g-recaptcha-response"]

      if grecaptcha.blank?

      	raise UserError, "Вы не заполнили проверку \"Я не робот\"."

      end
   
      status = verify_google_recptcha(secret_key('RECAPTCHA_PRIVATE_KEY'), grecaptcha)

      unless status

		raise UserError, "Вы неправильно заполнили проверку \"Я не робот\"."

      end      

    end	

end