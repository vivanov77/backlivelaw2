class Api::ChatMessagesController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_chat_message, only: [:show, :update, :destroy]

  # GET /chat_messages
  # GET /chat_messages.json
  def index

    if current_user

      chat_messages = ChatMessage

      chat_messages = chat_messages.where(sendable_type: "User").where(sendable_id: current_user.id)

      if params[:correspondent_type] && params[:correspondent_id]

        if params[:correspondent_type] == "guest"

          correspondent_type = "GuestChatToken"

        elsif params[:correspondent_type] == "user"

          correspondent_type = "User"

        end          

        chat_messages = chat_messages.where(receivable_type: correspondent_type).where(receivable_id: params[:correspondent_id])

      end

      chat_messages = chat_messages.order(:created_at)

      if chat_messages

        render json: chat_messages

      else

        error_message = "No chat_messages for the user '#{current_user.email}' are found."

        render json: { errors: error_message }, status: :unprocessable_entity        

      end

    else

      unless params[:guest_chat_password]

        error_message = "No guest_chat_password param specified."

        render json: { errors: error_message }, status: :unprocessable_entity and return  

      end

      guest_chat_password = params[:guest_chat_password]    

      guest_chat_token = GuestChatToken.find_by guest_chat_password: guest_chat_password

      unless guest_chat_token

        error_message = "The guest_chat_token for the guest_chat_password '#{guest_chat_password}' is not found."

        render json: { errors: error_message }, status: :unprocessable_entity and return

      end

      chat_messages = ChatMessage

      chat_messages = ChatMessage.where(sendable_type: "GuestChatToken").where(sendable_id: guest_chat_token.id)

      if params[:correspondent_id]

        chat_messages = chat_messages.where(receivable_type: "User").where(receivable_id: params[:correspondent_id])

      end      

      chat_messages = chat_messages.order(:created_at)

      if chat_messages

        render json: chat_messages

      else

        error_message = "No chat_messages for the guest_chat_password '#{guest_chat_password}' are found."

        render json: { errors: error_message }, status: :unprocessable_entity        

      end

    end  

  end

  # GET /chat_messages/1
  # GET /chat_messages/1.json
  # def show
  #   render json: @chat_message
  # end

  # POST /chat_messages
  # POST /chat_messages.json
  # def create
  #   @chat_message = Message.new(chat_message_params)

  #   if @chat_message.save
  #     render json: @chat_message, status: :created, location: [:api, @chat_message]
  #   else
  #     render json: @chat_message.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /chat_messages/1
  # # PATCH/PUT /chat_messages/1.json
  # def update
  #   if @chat_message.update(chat_message_params)
  #     render json: @chat_message
  #   else
  #     render json: @chat_message.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /chat_messages/1
  # DELETE /chat_messages/1.json
  # def destroy
  #   @chat_message.destroy
  #   render json: "Сообщение с id=\"#{@chat_message.id}\" успешно удалено".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_message
      @chat_message = ChatMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_message_params
      # params.require(:chat_message).permit(:title)
# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md
      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if user_signed_in?

        res[:sender_id] = current_user.id

      end

      res

    end
end
