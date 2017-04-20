# https://www.pluralsight.com/guides/ruby-ruby-on-rails/creating-a-chat-using-rails-action-cable
class MessageChannel < ApplicationCable::Channel
  def subscribed

    correspondent = params["correspondent"]

    correspondent_user = User.find_by email: correspondent

    if correspondent_user

      message_chanel_token = doubled_signed_token current_user.email, correspondent

      stream_from "message_#{message_chanel_token}_channel"  

    else
# http://api.rubyonrails.org/classes/ActionCable/Channel/Base.html#class-ActionCable::Channel::Base-label-Rejecting+subscription+requests
      reject

    end

  end
 
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
 
  def process_message_on_server param_message

    correspondent = params["correspondent"]

    correspondent_user = User.find_by email: correspondent

    if correspondent_user

      message_chanel_token = doubled_signed_token current_user.email, correspondent

      message = current_user.messages.create!(text: param_message['text'], recipient_id: correspondent_user.id)

      # DEBUG:
      # message = Message.new name: param_message['name'], content: param_message['content']

      # message = { name: param_message['name'], content: param_message['content'] }

      ActionCable.server.broadcast "message_#{message_chanel_token}_channel",
                                   sent_message: message

    end

  end

  def writing_progress

      correspondent = params["correspondent"]

      message_chanel_token = doubled_signed_token current_user.email, correspondent

      ActionCable.server.broadcast "message_#{message_chanel_token}_channel",
                             "__writing" => :true
  end   

end
