class Api::SecretChatTokensController < Api::ApplicationController

  # # GET /secret_chat_tokens
  # # GET /secret_chat_tokens.json
  # def index

  #   if params[:secret_chat_token_id]
  #     @secret_chat_tokens = ChatToken.where(id: params[:secret_chat_token_id])
  #     render json: @secret_chat_tokens, include: [:secret_chat_tokens], show_secret_chat_tokens: true
  #   else
  #     @secret_chat_tokens = ChatToken.order(:title)
  #     render json: @secret_chat_tokens
  #   end

  # end

  # GET /secret_chat_tokens/1
  # GET /secret_chat_tokens/1.json
  def show

    error_message = "You can't see secret_chat_token tokens"

    render json: { errors: error_message }, status: :unprocessable_entity     

  end

  # POST /secret_chat_tokens
  # POST /secret_chat_tokens.json
  def create

     # && (current_user.has_role?(:lawyer) || current_user.has_role?(:advocate))

  # Ситуации:

  # 1. Гость чатится с юристом.

  # 1.1. Asker: current_user == nil, params: guest_chat_password, answerer
  # 1.2. Answerer: current_user == jurist, params: guest_chat_login (answerer = current_user.email)

  # 2. Клиент-пользователь чатится с юристом.

  # 2.1. Asker: current_user == client, params: answerer (client = current_user.email)
  # 2.2. Answerer: current_user == jurist, params: client_user (answerer = current_user.email)

    if params[:guest_chat_password] || params[:guest_chat_login]
      # Ситуация 1

      if params[:guest_chat_password] && !current_user
        # Ситуация 1.1

        unless params[:answerer]

          error_message = "No answerer param specified."

          render json: { errors: error_message }, status: :unprocessable_entity and return  

        end

        guest_chat_token = GuestChatToken.find_by guest_chat_password: params[:guest_chat_password]

        unless guest_chat_token

          error_message = "The guest_chat_token is not found."

          render json: { errors: error_message }, status: :unprocessable_entity and return

        end

        # Результат 1.1

        answerer_user = User.find_by email: params[:answerer]

        asker_type = :guest_chat_login

        asker_value = guest_chat_token.guest_chat_login

      elsif params[:guest_chat_login] && current_user &&
        (current_user.has_role?(:lawyer) || current_user.has_role?(:advocate))
        # Ситуация 1.2

        guest_chat_token = GuestChatToken.find_by guest_chat_login: params[:guest_chat_login]

        unless guest_chat_token

          error_message = "The guest_chat_token is not found."

          render json: { errors: error_message }, status: :unprocessable_entity and return

        end      

        # Результат 1.2

        answerer_user = current_user

        asker_type = :guest_chat_login

        asker_value = guest_chat_token.guest_chat_login      

      end

    elsif (params[:answerer] && current_user) || params[:client_user]
      # Ситуация 2

      if params[:answerer] && current_user && 
        (!(current_user.has_role?(:lawyer) || current_user.has_role?(:advocate)))
        # Ситуация 2.1

        # Результат 2.1

        answerer_user = User.find_by email: params[:answerer]

        asker_type = :client_user

        asker_value = current_user.email

      elsif params[:client_user] && current_user && 
        (current_user.has_role?(:lawyer) || current_user.has_role?(:advocate))
        # Ситуация 2.2

        client_user = User.find_by email: params[:client_user]

        unless client_user

          error_message = "The user #{params[:client_user]} is not found."

          render json: { errors: error_message }, status: :unprocessable_entity and return

        end

        # Результат 2.2

        answerer_user = current_user

        asker_type = :client_user

        asker_value = client_user.email

      end

    end

    unless answerer_user

      error_message = "The answerer user is not found."

      render json: { errors: error_message }, status: :unprocessable_entity and return

    end

    secret_chat_token = doubled_signed_token asker_value, answerer_user.email

    token_hash = {}

    token_hash[:asker_type] = asker_type

    token_hash[:asker_value] = asker_value

    token_hash[:answerer] = answerer_user.email

    token_hash[:secret_chat_token] = secret_chat_token

    render json: token_hash, status: :created    

      

    # if current_user

    #   unless params[:guest_chat_login]

    #     error_message = "No guest_chat_login param specified."

    #     render json: { errors: error_message }, status: :unprocessable_entity and return  

    #   end

    #   guest_chat_login = params[:guest_chat_login]    

    #   guest_chat_token = GuestChatToken.find_by guest_chat_login: guest_chat_login

    #   answerer_user = current_user

    # else

    #   unless params[:guest_chat_password]

    #     error_message = "No guest_chat_password param specified."

    #     render json: { errors: error_message }, status: :unprocessable_entity and return  

    #   end

    #   guest_chat_password = params[:guest_chat_password]    

    #   guest_chat_token = GuestChatToken.find_by guest_chat_password: guest_chat_password


    #   unless params[:answerer]

    #     error_message = "No answerer param specified."

    #     render json: { errors: error_message }, status: :unprocessable_entity and return  

    #   end

    #   answerer = params[:answerer]

    #   answerer_user = User.find_by email: answerer

    #   unless answerer_user

    #     error_message = "The user #{answerer} is not found."

    #     render json: { errors: error_message }, status: :unprocessable_entity and return

    #   end

    # end


    # unless guest_chat_token

    #   error_message = "The guest_chat_token is not found."

    #   render json: { errors: error_message }, status: :unprocessable_entity and return

    # end



    # unless (answerer_user.has_role?(:lawyer) || answerer_user.has_role?(:advocate))

    #   error_message = "The user #{answerer} is not jurist."

    #   render json: { errors: error_message }, status: :unprocessable_entity and return

    # end


    # secret_chat_token = doubled_signed_token guest_chat_token.guest_chat_password, answerer_user.email

    # token_hash = {}

    # token_hash[:guest_chat_login] = guest_chat_token.guest_chat_login

    # token_hash[:answerer] = answerer_user.email

    # token_hash[:secret_chat_token] = secret_chat_token

    # render json: token_hash, status: :created

  end

  # # PATCH/PUT /secret_chat_tokens/1
  # # PATCH/PUT /secret_chat_tokens/1.json
  # def update
  #   if @secret_chat_token.update(secret_chat_token_params)
  #     render json: @secret_chat_token
  #   else
  #     render json: @secret_chat_token.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /secret_chat_tokens/1
  # DELETE /secret_chat_tokens/1.json
  # def destroy
  #   @secret_chat_token.destroy
  #   render json: "Комментарий с id=\"#{@secret_chat_token.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_secret_chat_token
    #   @secret_chat_token = ChatToken.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def secret_chat_token_params
      # params.require(:secret_chat_token).permit(:title)
# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/master/docs/general/deserialization.md
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)

    end
end
