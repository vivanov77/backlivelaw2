# https://www.pluralsight.com/guides/ruby-ruby-on-rails/creating-a-chat-using-rails-action-cable
class ChatChannel < ApplicationCable::Channel
  def subscribed

    if params["answerer_id"]

      answerer_id = params["answerer_id"]

      answerer_user = User.find answerer_id

      if answerer_user

        asker_type = nil

        chat_chanel_token = signed_token answerer_user.email

        stream_from "chat_#{chat_chanel_token}_channel"

        if current_user.class.to_s == "GuestChatToken"

          asker_type = :guest_chat_login
          asker_value = current_user.guest_chat_login

        elsif current_user.class.to_s == "User" && 
          (!(current_user.has_role?(:lawyer) || current_user.has_role?(:jurist)))

          asker_type = :client_user_id
          asker_value = current_user.id
                                      
        end

        if asker_type
          
          message = { asker_type: asker_type, asker_value: asker_value, chat_subscribed: :on }

          ActionCable.server.broadcast "chat_#{chat_chanel_token}_channel",
                                     chat_request: message
        end

      else
  # http://api.rubyonrails.org/classes/ActionCable/Channel/Base.html#class-ActionCable::Channel::Base-label-Rejecting+subscription+requests

        connection.transmit identifier: params, error: "The user #{answerer} is not found."

        reject

      end

    elsif params["secret_chat_token"]

      secret_chat_token = params["secret_chat_token"]

      chat_chanel_token = secret_chat_token

      stream_from "chat_#{chat_chanel_token}_channel"

    else

        connection.transmit identifier: params, error: "No params are specified."

        reject

    end     

  end
 
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed

    if identifier.include? "secret_chat_token"

      token = identifier["secret_chat_token"]

      if current_user.class.to_s == "GuestChatToken"

          asker_type = :guest_chat_login
          asker_value = current_user.guest_chat_login

      elsif current_user.class.to_s == "User"

        if (current_user.has_role?(:lawyer) || current_user.has_role?(:jurist))
          asker_type = :answerer_id
        else
          asker_type = :client_user_id 
        end
          
        asker_value = current_user.id

      end

      message = { asker_type: asker_type, asker_value: asker_value, chat_subscribed: :off }

      ActionCable.server.broadcast stream_name, chat_cancel: message if stream_name

      chat_session = ChatSession.where(secret_chat_token: token, finished: false).first

      if chat_session

        chat_session.finished = true

        chat_session.save!

      end

    end

  end

  def process_accept_on_server param_message

    if params["secret_chat_token"]

      token = params["secret_chat_token"]

      unless param_message["chat_request_accept"]

        message = { message_error: "The param 'chat_request_accept' is missing. Secret_chat_token = " + token }

        ActionCable.server.broadcast "chat_#{token}_channel", message 

        return
        
      end

      if (current_user.has_role?(:lawyer) || current_user.has_role?(:jurist))

        chat_session = ChatSession.where(secret_chat_token: token, finished: false).first

        chat_parties_array = secret_token_users token, "secret_chat_token"

        if chat_parties_array.size == 1

          message = { message_error: "Only 1 chat party. Minimum required = 2. Secret_chat_token = " + token }

        elsif chat_parties_array.size > 2

          message = { message_error: "More than 2 parties in the chat. Secret_chat_token = " + token }

        elsif chat_session

          message = { message_error: "Some previous chat session is pending. Aborting. Secret_chat_token = " + token }

        else

          correspondent_index = 1 - chat_parties_array.index(current_user)

          correspondent_user = chat_parties_array[correspondent_index]

          # Начинаем чат-сессию
          if param_message["chat_request_accept"] == "true"

            chat_session = ChatSession.create specialist_id: current_user.id, 
            clientable_type: correspondent_user.class.to_s,
            clientable_id: correspondent_user.id,
            secret_chat_token: token

          end        

          message = { answerer_id: current_user.id, chat_request_accept: param_message["chat_request_accept"] }
        
        end

      else

        message = { answerer: nil, wrong_accept_answerer: true }

      end

      ActionCable.server.broadcast "chat_#{token}_channel", message

    end    
    
  end  
 
  def process_message_on_server param_message

    # byebug
    # binding.pry  

    if params["secret_chat_token"]

      token = params["secret_chat_token"]

      unless param_message["text"]

        message = { message_error: "The param 'text' is missing. Secret_chat_token = " + token }

        ActionCable.server.broadcast "chat_#{token}_channel", message 

        return
        
      end

      chat_session = ChatSession.where(secret_chat_token: token, finished: false).first

      chat_parties_array = secret_token_users token, "secret_chat_token"

      if chat_parties_array.size == 1

        message = { message_error: "Only 1 chat party. Minimum required = 2. Secret_chat_token = " + token }

      elsif chat_parties_array.size > 2

        message = { message_error: "More than 2 parties in the chat. Secret_chat_token = " + token }

      elsif !chat_session

          message = { message_error: "Active chat session is not found. Aborting. Secret_chat_token = " + token }

      else

        correspondent_index = 1 - chat_parties_array.index(current_user)

        correspondent_user = chat_parties_array[correspondent_index]

        message = { sendable_type: current_user.class.to_s, sendable_id: current_user.id,
          receivable_type: correspondent_user.class.to_s, receivable_id: correspondent_user.id,
          text: param_message["text"],
          chat_session_id: chat_session.id }

        chat_message = ChatMessage.new(message)

        unless chat_message.save

          message = { message_error: "The chat message was not saved: #{message}. Secret_chat_token = " + token }

        end

      end

      ActionCable.server.broadcast "chat_#{token}_channel", message
      
    end

  end



  def writing_progress

    # byebug
    # binding.pry

    if params["secret_chat_token"]

      token = params["secret_chat_token"]

      chat_parties_array = secret_token_users token, "secret_chat_token"

      if chat_parties_array.size == 1

        message = { message_error: "Only 1 chat party. Minimum required = 2. Secret_chat_token = " + token }

      elsif chat_parties_array.size > 2

        message = { message_error: "More than 2 parties in the chat. Secret_chat_token = " + token }

      else

        correspondent_index = 1 - chat_parties_array.index(current_user)

        correspondent_user = chat_parties_array[correspondent_index]   

        message = { sendable_type: current_user.class.to_s, sendable_id: current_user.id,
          receivable_type: correspondent_user.class.to_s, receivable_id: correspondent_user.id,
          writing_progress: true }

      end

      ActionCable.server.broadcast "chat_#{token}_channel", message
      
    end

  end

end