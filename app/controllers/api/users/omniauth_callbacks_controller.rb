class Api::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  def facebook

    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

  def omniauth_success
    success_message = "User logged in"

    render json: { success: success_message }, status: :ok 
  end
  
  # def vkontakte

  #   p "api_vkontakte"
    
  #   # @user = User.from_omniauth_vkontakte(request.env["omniauth.auth"])
  #   @user = User.last

  #   user = @user

  #   @client_id = SecureRandom.urlsafe_base64(nil, false)
  #   @token     = SecureRandom.urlsafe_base64(nil, false)

  #   user.tokens[@client_id] = {
  #     token: BCrypt::Password.create(@token),
  #     expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
  #   }
  #   user.save


  #   @resource = user

  #   sign_in(:user, @resource, store: false, bypass: false)

  #   render json: user
        


  #   # if @user.persisted?
  #   #   sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #   #   set_flash_message(:notice, :success, :kind => "Vkontakte") if is_navigational_format?
  #   # else
  #   #   session["devise.vkontakte_data"] = request.env["omniauth.auth"]
  #   #   redirect_to new_user_registration_url
  #   # end    
  # end  

end
