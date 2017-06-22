class Api::Users::SessionsController < DeviseTokenAuth::SessionsController

# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # def create

  #   p "short_login"

  #   user = User.find_by email: params[:email]

  #       @client_id = SecureRandom.urlsafe_base64(nil, false)
  #       @token     = SecureRandom.urlsafe_base64(nil, false)

  #       user.tokens[@client_id] = {
  #         token: BCrypt::Password.create(@token),
  #         expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
  #       }
  #       user.save


  #       @resource = user

  #       sign_in(:user, @resource, store: false, bypass: false)

  #       render json: user

  # end

  # POST /resource/sign_in
  def create

    # p "Users::SessionsController.create"

    user = User.find_by email: params[:email] 

    if user && (user.has_role? :admin)

      error_message = "Пользователи с ролью администратора могут заходить только в админку."

      render json: { errors: error_message }, status: :unprocessable_entity and return

    else    
      super
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def render_create_success
    render json: @resource, include: [:roles], show_roles: true
  end
end
