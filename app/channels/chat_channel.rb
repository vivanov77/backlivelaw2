# https://www.pluralsight.com/guides/ruby-ruby-on-rails/creating-a-chat-using-rails-action-cable
class ChatChannel < ApplicationCable::Channel
  def subscribed

    if params["answerer"]

      answerer = params["answerer"]

      chat_chanel_token = signed_token answerer

      answerer_user = User.find_by email: answerer

      if answerer_user

        asker_type = nil

        stream_from "chat_#{chat_chanel_token}_channel"

        if current_user.class.to_s == "GuestChatToken"

          asker_type = :guest_chat_login
          asker_value = current_user.guest_chat_login

        elsif current_user.class.to_s == "User" && 
          (!(current_user.has_role?(:lawyer) || current_user.has_role?(:advocate)))

          asker_type = :client_user
          asker_value = current_user.email
                                      
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

      if current_user.class.to_s == "GuestChatToken"

          asker_type = :guest_chat_login
          asker_value = current_user.guest_chat_login

      elsif current_user.class.to_s == "User"

        if (current_user.has_role?(:lawyer) || current_user.has_role?(:advocate))
          asker_type = :answerer
        else
          asker_type = :client_user          
        end
          
        asker_value = current_user.email

      end

      message = { asker_type: asker_type, asker_value: asker_value, chat_subscribed: :off }

      ActionCable.server.broadcast stream_name, chat_cancel: message if stream_name

    end

  end
 
  def process_message_on_server param_message

    # byebug
    # binding.pry

    if params["secret_chat_token"] && param_message["text"]

      secret_chat_token = params["secret_chat_token"]

      chat_chanel_token = secret_chat_token


      chat_parties_array = secret_token_users secret_chat_token, "secret_chat_token"

      unless chat_parties_array.size > 2

        correspondent_index = 1 - chat_parties_array.index(current_user)

        correspondent_user = chat_parties_array[correspondent_index]
   

        message = { sendable_type: current_user.class, sendable_id: current_user.id,
          receivable_type: correspondent_user.class, receivable_id: correspondent_user.id,
          text: param_message["text"] }

        chat_message = ChatMessage.new(message)

        unless chat_message.save

          message = { message_error: "The chat message was not saved: #{message}. Secret_chat_token = " + secret_chat_token }

        end

      else

        message = { message_error: "More than 2 parties in the chat. Secret_chat_token = " + secret_chat_token }

      end

      ActionCable.server.broadcast "chat_#{chat_chanel_token}_channel", message
      
    end

  end

  def process_accept_on_server param_message

    if params["secret_chat_token"] && param_message["chat_request_accept"]

      secret_chat_token = params["secret_chat_token"]

      chat_chanel_token = secret_chat_token

      if (current_user.has_role?(:lawyer) || current_user.has_role?(:advocate))

        message = { answerer: current_user.email, chat_request_accept: param_message["chat_request_accept"] }

      else

        message = { answerer: nil, wrong_accept_answerer: true }

      end

      ActionCable.server.broadcast "chat_#{chat_chanel_token}_channel", message

    end    
    
  end

  def writing_progress

    # byebug
    # binding.pry

    if params["secret_chat_token"]

      secret_chat_token = params["secret_chat_token"]

      chat_chanel_token = secret_chat_token


      chat_parties_array = secret_token_users secret_chat_token, "secret_chat_token"

      unless chat_parties_array.size > 2

        correspondent_index = 1 - chat_parties_array.index(current_user)

        correspondent_user = chat_parties_array[correspondent_index]
   

        message = { sendable_type: current_user.class, sendable_id: current_user.id,
          receivable_type: correspondent_user.class, receivable_id: correspondent_user.id,
          writing_progress: true }

      else

        message = { message_error: "More than 2 parties in the chat. Secret_chat_token = " + secret_chat_token }

      end

      ActionCable.server.broadcast "chat_#{chat_chanel_token}_channel", message
      
    end

  end



end



