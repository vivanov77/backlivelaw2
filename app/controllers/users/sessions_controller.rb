class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create

    user = User.find_by email: sign_in_params[:email]
    if user && (!user.has_role? :admin)
      # sign_out
      redirect_to user_session_path, notice: "Заходить в админку можно только администраторам. (admin@example.com)"
    else    
      super
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
