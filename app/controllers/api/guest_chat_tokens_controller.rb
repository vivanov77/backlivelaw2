class Api::GuestChatTokensController < Api::ApplicationController

  # # GET /guest_chat_tokens
  # # GET /guest_chat_tokens.json
  # def index

  #   if params[:guest_chat_token_id]
  #     @guest_chat_tokens = ChatToken.where(id: params[:guest_chat_token_id])
  #     render json: @guest_chat_tokens, include: [:guest_chat_tokens], show_guest_chat_tokens: true
  #   else
  #     @guest_chat_tokens = ChatToken.order(:title)
  #     render json: @guest_chat_tokens
  #   end

  # end

  # GET /guest_chat_tokens/1
  # GET /guest_chat_tokens/1.json
  def show 

    error_message = "You can't see guest_chat_token tokens"

    render json: { errors: error_message }, status: :unprocessable_entity    

  end

  # POST /guest_chat_tokens
  # POST /guest_chat_tokens.json
  def create

    if current_user

      error_message = "Only guests may create the guest_chat_token"

      render json: { errors: error_message }, status: :unprocessable_entity and return

    end    

    @guest_chat_token = GuestChatToken.new(guest_chat_token_params)

    if @guest_chat_token.save
      render json: @guest_chat_token, status: :created, location: [:api, @guest_chat_token]
    else
      render json: @guest_chat_token.errors, status: :unprocessable_entity
    end

  end

  # # PATCH/PUT /guest_chat_tokens/1
  # # PATCH/PUT /guest_chat_tokens/1.json
  # def update
  #   if @guest_chat_token.update(guest_chat_token_params)
  #     render json: @guest_chat_token
  #   else
  #     render json: @guest_chat_token.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /guest_chat_tokens/1
  # DELETE /guest_chat_tokens/1.json
  # def destroy
  #   @guest_chat_token.destroy
  #   render json: "Комментарий с id=\"#{@guest_chat_token.id}\" успешно удалён".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_guest_chat_token
    #   @guest_chat_token = ChatToken.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guest_chat_token_params
      # params.require(:guest_chat_token).permit(:title)
# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)

    end
end
