class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
      include DeviseTokenAuth::Concerns::SetUserByToken
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
# https://stackoverflow.com/questions/44657191/devise-token-auth-omniauth-json-response/44698754#44698754 
    namespace_name = request.env["omniauth.params"]["namespace_name"]    

    if @user.persisted?
      
      if namespace_name && namespace_name == "api"

        @client_id = SecureRandom.urlsafe_base64(nil, false)
        @token     = SecureRandom.urlsafe_base64(nil, false)

        @user.tokens[@client_id] = {
          token: BCrypt::Password.create(@token),
          expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
        }
        @user.save

        @resource = @user # trade-off for "update_auth_header" defined in "DeviseTokenAuth::Concerns::SetUserByToken"

        sign_in(:user, @user, store: false, bypass: false)        

        render json: @user

      else
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      end
      
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
  
  def vkontakte
    @user = User.from_omniauth_vkontakte(request.env["omniauth.auth"])
# https://stackoverflow.com/questions/44657191/devise-token-auth-omniauth-json-response/44698754#44698754 
    namespace_name = request.env["omniauth.params"]["namespace_name"]

    if @user.persisted?

      if namespace_name && namespace_name == "api"

        @client_id = SecureRandom.urlsafe_base64(nil, false)
        @token     = SecureRandom.urlsafe_base64(nil, false)

        @user.tokens[@client_id] = {
          token: BCrypt::Password.create(@token),
          expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
        }
        @user.save

        @resource = @user # trade-off for "update_auth_header" defined in "DeviseTokenAuth::Concerns::SetUserByToken"

        sign_in(:user, @user, store: false, bypass: false)        

        render json: @user

      else

        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Vkontakte") if is_navigational_format?

      end

    else
      session["devise.vkontakte_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end    
  end

  
end
