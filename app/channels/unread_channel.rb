# https://www.pluralsight.com/guides/ruby-ruby-on-rails/creating-a-chat-using-rails-action-cable
class UnreadChannel < ApplicationCable::Channel
  def subscribed

    if current_user.class.to_s = "User"

      unread_chanel_token = signed_token current_user.email

      stream_from "unread_#{unread_chanel_token}_channel"

    else
# http://api.rubyonrails.org/classes/ActionCable/Channel/Base.html#class-ActionCable::Channel::Base-label-Rejecting+subscription+requests
      reject

    end

  end
 
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
 
  def process_unread_on_server param_message

    correspondent = param_message["correspondent"]

    correspondent_user = User.find_by email: correspondent

    if correspondent_user && (current_user.class.to_s == "User")

      unread_chanel_token = signed_token correspondent

      ActionCable.server.broadcast "unread_#{unread_chanel_token}_channel",
                                   sender_id: current_user.id
    end

  end

end
