# https://www.pluralsight.com/guides/ruby-ruby-on-rails/creating-a-chat-using-rails-action-cable
class AppearanceChannel < ApplicationCable::Channel
  def subscribed

    stream_from "appearance_channel"

    if current_user.class.to_s == "User"

      ActionCable.server.broadcast "appearance_channel", { user_id: current_user.id, online: :on }

      current_user.online = true

      current_user.save!

    end


  end
 
  def unsubscribed

    if current_user.class.to_s == "User"

      # Any cleanup needed when channel is unsubscribed
      ActionCable.server.broadcast "appearance_channel", { user_id: current_user.id, online: :off }

      current_user.online = false

      current_user.save!      

    end


  end 

end
