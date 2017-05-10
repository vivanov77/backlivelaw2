# https://www.pluralsight.com/guides/ruby-ruby-on-rails/creating-a-chat-using-rails-action-cable
class UnreadChannel < ApplicationCable::Channel
  def subscribed

    if current_user.class.to_s == "User"

      # unread_chanel_token = signed_token current_user.email
      unread_chanel_token = current_user.id

      stream_from "unread_#{unread_chanel_token}_channel"

    else

      connection.transmit identifier: params, error: "Only users may subscribe to the UnreadChannel."

# http://api.rubyonrails.org/classes/ActionCable/Channel/Base.html#class-ActionCable::Channel::Base-label-Rejecting+subscription+requests
      reject

    end

  end
 
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
 
  def process_unread_on_server param_message

    unless param_message["correspondent_id"]

      message = { message_error: "The 'correspondent_id' param is missing." }

    end

    correspondent_id = param_message["correspondent_id"]

    unless (correspondent_user = User.find correspondent_id)

      message = { message_error: "The #{correspondent_id} user is not found." }

    end

    unless current_user.class.to_s == "User"

      message = { message_error: "Only users may message to the UnreadChannel." }

    end

    # unread_chanel_token = signed_token correspondent
    unread_chanel_token = correspondent_id

    unless message

      message = { sender_id: current_user.id, receiver_id: correspondent_id }

    end

    ActionCable.server.broadcast "unread_#{unread_chanel_token}_channel", message
                                       
  end

end
