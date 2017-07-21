class Api::SecretMessageTokensController < Api::ApplicationController

  # # GET /secret_message_tokens
  # # GET /secret_message_tokens.json
  # def index

  #   if params[:secret_message_token_id]
  #     @secret_message_tokens = SecretMessageToken.where(id: params[:secret_message_token_id])
  #     render json: @secret_message_tokens, include: [:secret_message_tokens], show_secret_message_tokens: true
  #   else
  #     @secret_message_tokens = SecretMessageToken.order(:title)
  #     render json: @secret_message_tokens
  #   end

  # end

  # GET /secret_message_tokens/1
  # GET /secret_message_tokens/1.json
  def show 

    error_message = "You can't see secret message tokens"

    render json: { errors: error_message }, status: :unprocessable_entity    

  end

  # POST /secret_message_tokens
  # POST /secret_message_tokens.json
  def create

    unless params[:correspondent_id]

      error_message = "No 'correspondent_id' param specified."

      render json: { errors: error_message }, status: :unprocessable_entity and return  

    end

    unless current_user

      error_message = "Only users may create the secret message token"

      render json: { errors: error_message }, status: :unprocessable_entity and return

    end

    correspondent_user = User.find params[:correspondent_id]

    unless correspondent_user

      error_message = "The user #{params[:correspondent_id]} is not found."

      render json: { errors: error_message }, status: :unprocessable_entity and return

    end

    secret_message_token = doubled_signed_token current_user.email, correspondent_user.email

    token_hash = {}

    token_hash[:sender] = current_user.email

    token_hash[:receiver] = correspondent_user.email

    token_hash[:secret_message_token] = secret_message_token

    render json: token_hash, status: :created       

    # @secret_message_token = SecretMessageToken.new(secret_message_token_params)

    # if @secret_message_token.save
    #   render json: @secret_message_token, status: :created, location: [:api, @secret_message_token]
    # else
    #   render json: @secret_message_token.errors, status: :unprocessable_entity
    # end

  end

  # # PATCH/PUT /secret_message_tokens/1
  # # PATCH/PUT /secret_message_tokens/1.json
  # def update
  #   if @secret_message_token.update(secret_message_token_params)
  #     render json: @secret_message_token
  #   else
  #     render json: @secret_message_token.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /secret_message_tokens/1
  # DELETE /secret_message_tokens/1.json
  # def destroy
  #   @secret_message_token.destroy
  #   render json: "Комментарий с id=\"#{@secret_message_token.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_secret_message_token
    #   @secret_message_token = SecretMessageToken.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def secret_message_token_params
      # params.require(:secret_message_token).permit(:title)
# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)

    end
end
