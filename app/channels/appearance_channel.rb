# https://www.pluralsight.com/guides/ruby-ruby-on-rails/creating-a-chat-using-rails-action-cable
class AppearanceChannel < ApplicationCable::Channel
  def subscribed

    stream_from "appearance_channel"

    if current_user

      ActionCable.server.broadcast "appearance_channel", { user: current_user.id, online: :on }

      current_user.online = true

      current_user.save!

    end


  end
 
  def unsubscribed

    if current_user

      # Any cleanup needed when channel is unsubscribed
      ActionCable.server.broadcast "appearance_channel", { user: current_user.id, online: :off }

      current_user.online = false

      current_user.save!      

    end


  end 

end
