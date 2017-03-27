class Api::MessagesController < Api::ApplicationController

  # before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_message, only: [:show, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index

    if params[:user]

      user = User.find_by email: params[:user]

      if user

        if params[:correspondent]

            correspondent = User.find_by email: params[:correspondent]

            if correspondent

              @messages = Message.messages user.id, correspondent.id

              render json: @messages

            else

              error_message = "Пользователь #{params[:correspondent]} не существует."

              render json: { errors: error_message }, status: :unprocessable_entity

            end

        else
  
          correspondents = Message.correspondents user.id

          if correspondents.size > 0

            @messages = Message.last_messages user.id, correspondents

            render json: @messages

          else

            error_message = "Пользователь #{params[:user]} ещё не посылал и не получал сообщений."

            render json: { errors: error_message }, status: :unprocessable_entity          

          end

        end

      else

        error_message = "Пользователь #{params[:user]} не существует."

        render json: { errors: error_message }, status: :unprocessable_entity

      end

    else

      @messages = []

      render json: @messages

    end

  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    render json: @message
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    if @message.save
      render json: @message, status: :created, location: [:api, @message]
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  # def destroy
  #   @message.destroy
  #   render json: "Сообщение с id=\"#{@message.id}\" успешно удалено".to_json, status: :ok    
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      # params.require(:message).permit(:title)
# https://www.simplify.ba/articles/2016/06/18/creating-rails5-api-only-application-following-jsonapi-specification/
# https://github.com/rails-api/active_model_serializers/blob/master/docs/general/deserialization.md
      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if user_signed_in?

        res[:sender_id] = current_user.id

      end

      res

    end
end
