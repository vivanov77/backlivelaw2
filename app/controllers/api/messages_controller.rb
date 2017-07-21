class Api::MessagesController < Api::ApplicationController

  before_action :authenticate_user!
  # load_and_authorize_resource
    
  before_action :set_message, only: [:show, :update, :destroy]

  before_action :mark_messages_read, only: [:create]

  before_action :unread_messages_count, only: [:index]

  before_action :check_own_message, only: [:show, :update]    

  # GET /messages
  # GET /messages.json
  def index

    if params[:correspondent_id]

        correspondent = User.find params[:correspondent_id]

        if correspondent

          # ActiveRecord::Base.transaction do
# http://www.codeatmorning.com/rails-transactions-complete-guide/
            @messages = Message.dialog_messages current_user.id, correspondent.id

            render json: @messages

          # end

        else

          error_message = "Пользователь #{params[:correspondent_id]} не существует."

          render json: { errors: error_message }, status: :unprocessable_entity

        end

    elsif param? params[:all_dialogs]

      correspondents = Message.correspondents current_user.id

      if correspondents.size > 0

        @messages = Message.last_messages current_user.id, correspondents

        render json: @messages

      else

        error_message = "Пользователь #{current_user.email} ещё не посылал и не получал сообщений."

        render json: { errors: error_message }, status: :unprocessable_entity

      end

    elsif param? params[:search_correspondent_email]

      search_email = params[:search_correspondent_email]

      # https://stackoverflow.com/questions/44372006/thinkingsphinx-dynamic-indices-on-the-sql-backed-indices

      current_user_email = "\"" + current_user.email + "\""

      messages = Message.search(
        "(@sender_email #{current_user_email} @recipient_email #{search_email}) | \

        (@sender_email #{search_email} @recipient_email #{current_user_email})"
      )      


      messages1 = []

      messages.each do |m|

        h = {}

        if current_user.id == m.sender_id

          h[:message] = m

          h[:user_id] = m.sender_id

          h[:user_email] = m.sender.email

          h[:correspondent_id] = m.recipient_id

          h[:correspondent_email] = m.recipient.email

          h[:direct_message] = true

        else

          h[:message] = m

          h[:user_id] = m.recipient_id

          h[:user_email] = m.recipient.email        

          h[:correspondent_id] = m.sender_id

          h[:correspondent_email] = m.sender.email

          h[:direct_message] = false

        end

        selected = messages1.select do |s| 

          s[:user_id] == h[:user_id] && s[:correspondent_id] == h[:correspondent_id]

        end

        s = selected.try(:first)

        if s

          if (s[:message].updated_at < m.updated_at)

            i = messages1.index s

            # p "wiped out:", s

            messages1[i] = h

          else

            # p "wiped out:", h

          end

        else

          messages1 << h

        end

        # messages1 << h

      end

      messages1.sort_by { |hsh| hsh[:correspondent_email] }

      render json: messages1

    elsif (param? params[:search_dialog_text]) && (param? params[:correspondent_id])

      search_text = params[:search_dialog_text]

      correspondent_id = params[:correspondent_id]

      conditions = {text: search_text}

      with_current_user_dialog = 

"*, IF((sender_id = #{current_user.id} AND recipient_id = #{correspondent_id}) OR \

(sender_id = #{correspondent_id} AND recipient_id = #{current_user.id}), 1, 0) \

AS current_user_dialog"
      
      messages = Message.search search_text, conditions: conditions,
        :select => with_current_user_dialog,
        :with  => {'current_user_dialog' => 1}

      render json: messages

    else

        error_message = "Не указаны параметры."

        render json: { errors: error_message }, status: :unprocessable_entity

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
# https://github.com/rails-api/active_model_serializers/blob/v0.10.6/docs/general/deserialization.md
      res = ActiveModelSerializers::Deserialization.jsonapi_parse(params)

      if user_signed_in?

        res[:sender_id] = current_user.id

      end

      res

    end


    def unread_messages_count

      if params[:unread_all]

        unread = Message.unread_count_all current_user.id

        if unread

          mes_unread = {
            "messages": {
              "user_id": current_user.id,
              "messages_unread_all": unread
            }
          }

          render json: mes_unread

        else

          error_message = "Не удалось подсчитать непрочитанные сообщения для текущего пользователя."
          
          render json: { errors: error_message }, status: :unprocessable_entity

        end        


      elsif params[:unread_id] && (correspondent = User.find params[:unread_id])

        unread = Message.unread_count current_user.id, correspondent.id

        if unread

          mes_unread = {
            "messages": {
              "user_id": current_user.id,
              "correspondent_id": correspondent.id,
              "messages_unread": unread
            }
          }

          render json: mes_unread

        else

          error_message = "Не удалось подсчитать непрочитанные сообщения пользователя: \"#{@user.email}\"."
          
          render json: { errors: error_message }, status: :unprocessable_entity

        end
      end
    end

    def mark_messages_read

      if params[:mark_read_id] && (correspondent = User.find params[:mark_read_id])

        if (messages = Message.mark_messages_read current_user.id, correspondent.id)

          render json: messages

        else

          error_message = "Не удалось пометить прочитанными непрочитанные сообщения пользователя: \"#{@user.email}\"."
          
          render json: { errors: error_message }, status: :unprocessable_entity

        end

      end

    end

    def check_own_message

      unless (@message.sender_id == current_user.id) || (@message.recipient_id == current_user.id)

        error_message = "Можно просматривать только свои сообщения (и для себя)."
        
        render json: { errors: error_message }, status: :unprocessable_entity

      end

    end

end