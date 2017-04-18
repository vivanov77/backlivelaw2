# https://www.pluralsight.com/guides/ruby-ruby-on-rails/creating-a-chat-using-rails-action-cable
class UnreadChannel < ApplicationCable::Channel
  def subscribed

    access_token = params["access-token"]
    uid = params["uid"]
    client = params["client"]

    unread_chanel_token = signed_token uid

    user = User.find_by email: uid

    if user && user.valid_token?(access_token, client)

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

    if correspondent_user

      unread_chanel_token = signed_token correspondent

      ActionCable.server.broadcast "unread_#{unread_chanel_token}_channel",
                                   sender_id: current_user.id
    end

  end

end
