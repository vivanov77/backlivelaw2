# https://www.pluralsight.com/guides/ruby-ruby-on-rails/creating-a-chat-using-rails-action-cable
class MessageChannel < ApplicationCable::Channel
  def subscribed

    if params["secret_message_token"]

      message_chanel_token = params["secret_message_token"]

      stream_from "message_#{message_chanel_token}_channel"

    else

        connection.transmit identifier: params, error: "No 'secret_message_token' param is specified."

# http://api.rubyonrails.org/classes/ActionCable/Channel/Base.html#class-ActionCable::Channel::Base-label-Rejecting+subscription+requests
        reject

    end     

#     correspondent = params["correspondent"]

#     correspondent_user = User.find_by email: correspondent

#     if correspondent_user && (current_user.class.to_s == "User")

#       message_chanel_token = doubled_signed_token current_user.email, correspondent

#       stream_from "message_#{message_chanel_token}_channel"  

#     else

#       connection.transmit identifier: params, error: "No params are specified."


# # http://api.rubyonrails.org/classes/ActionCable/Channel/Base.html#class-ActionCable::Channel::Base-label-Rejecting+subscription+requests
#       reject

#     end

  end
 
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed

    if identifier.include? "secret_message_token"

      message = { user_id: current_user.id, message_subscribed: :off }

      ActionCable.server.broadcast stream_name, message_cancel: message if stream_name

    end

  end
 
  # def process_message_on_server param_message

  #   correspondent = params["correspondent"]

  #   correspondent_user = User.find_by email: correspondent

  #   if correspondent_user && (current_user.class.to_s == "User")

  #     message_chanel_token = doubled_signed_token current_user.email, correspondent

  #     message = current_user.messages.create!(text: param_message['text'], recipient_id: correspondent_user.id)

  #     # DEBUG:
  #     # message = Message.new name: param_message['name'], content: param_message['content']

  #     # message = { name: param_message['name'], content: param_message['content'] }

  #     ActionCable.server.broadcast "message_#{message_chanel_token}_channel",
  #                                  sent_message: message

  #   end

  # end

  def process_message_on_server param_message

    # byebug
    # binding.pry

    unless params["secret_message_token"]

      message = { message_error: "The 'secret_message_token' param is missing." }

    end

    token = params["secret_message_token"]    

    unless param_message["text"]

      message = { message_error: "The 'text' param is missing." }

    end

    unless  param_message["correspondent_id"]

      message = { message_error: "The 'correspondent_id' param is missing." }

    end

    unless (correspondent_user = User.find param_message["correspondent_id"])

      message = { message_error: "The 'correspondent_id' user is not found." }

    end

    if message

      ActionCable.server.broadcast "message_#{token}_channel", message and return   

    end

    message_hash = { sender_id: current_user.id, recipient_id: correspondent_user.id,
      text: param_message["text"] }

    message = { sender_id: current_user.id,
      recipient_id: correspondent_user.id,
      text: param_message["text"] }

    message_db = Message.new(message_hash)

    unless message_db.save

      message = { message_error: "The chat message was not saved: #{message_hash}. Secret_message_token = " + token }

    end

    ActionCable.server.broadcast "message_#{token}_channel", message

  end  

  # def writing_progress

  #     correspondent = params["correspondent"]

  #     message_chanel_token = doubled_signed_token current_user.email, correspondent

  #     ActionCable.server.broadcast "message_#{message_chanel_token}_channel",
  #                            "__writing" => :true
  # end   

  def writing_progress param_message

    # byebug
    # binding.pry

    unless params["secret_message_token"]

      message = { message_error: "The 'secret_message_token' param is missing." }

    end

    token = params["secret_message_token"]

    unless  param_message["correspondent_id"]

      message = { message_error: "The 'correspondent_id' param is missing." }

    end

    unless (correspondent_user = User.find param_message["correspondent_id"])

      message = { message_error: "The 'correspondent' user is not found." }

    end

    unless message

      message = { sender_id: current_user.id,
        recipient_id: correspondent_user.id, 
        writing_progress: true }      

    end

    ActionCable.server.broadcast "message_#{token}_channel", message

  end  

end
