# https://www.pluralsight.com/guides/ruby-ruby-on-rails/creating-a-chat-using-rails-action-cable
class ChatChannel < ApplicationCable::Channel
  def subscribed

    asker = params["asker"]
    
    answerer = params["answerer"]

    chat_chanel_token = doubled_signed_token asker, answerer

    answerer_user = User.find_by email: answerer

    if answerer_user

      stream_from "chat_#{chat_chanel_token}_channel"  

    else
# http://api.rubyonrails.org/classes/ActionCable/Channel/Base.html#class-ActionCable::Channel::Base-label-Rejecting+subscription+requests
      reject

    end

  end
 
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
 
  def process_message_on_server param_message  

    asker = params["asker"]
    
    answerer = params["answerer"]

    chat_chanel_token = doubled_signed_token asker, answerer    

    if answerer && (answerer_user = User.find_by email: answerer)      

      # message = current_user.messages.create!(text: param_message['text'], recipient_id: correspondent_user.id)

      # DEBUG:
      # message = Message.new name: param_message['name'], content: param_message['content']

      message = { name: "123", content: "456" }

      ActionCable.server.broadcast "chat_#{chat_chanel_token}_channel",
                                   sent_chat_message: message

    end

  end

  def writing_progress

      jurist = params["jurist"]

      chat_chanel_token = signed_token jurist

      ActionCable.server.broadcast "chat_#{chat_chanel_token}_channel",
                             "__writing" => :true
  end   

end
