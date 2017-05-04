# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	
  	# include ApplicationHelper

	identified_by :current_user

	def connect
# ws://localhost:3000/cable/?access-token=zZ12GuNyGYR5HM7yhYwPpg&client=Fgp76lGbk3xmqCzhBy1DbQ&uid=client1@example.com		

		params = request.query_parameters()

		if params["access-token"]

			access_token = params["access-token"]
			uid = params["uid"]
			client = params["client"]

			self.current_user = find_verified_user access_token, uid, client
			logger.add_tags 'ActionCable', user_email: current_user.email
		
		elsif params["guest_chat_login"]

			guest_chat_login = params["guest_chat_login"]

			self.current_user = find_guest_chat_token guest_chat_login
			logger.add_tags 'ActionCable', guest_chat_login: current_user.guest_chat_login

		else

			logger.add_tags 'ActionCable', "Please provide either 'access-token' or 'guest_chat_login' param. Connection rejected."

			self.transmit error: "Please provide either 'access-token' or 'guest_chat_login' param. Connection rejected."

			reject_unauthorized_connection

		end
	end


    protected

		def find_verified_user access_token, uid, client # this checks whether a user is authenticated with devise

			user = User.find_by email: uid

			if user

				if user.valid_token?(access_token, client)
					user
				else

					message = "The user \"#{uid}\" is not authenticated. Connection rejected."

					logger.add_tags 'ActionCable', message

					self.transmit error: message

					reject_unauthorized_connection
					
				end				

			else

				message = "The user \"#{uid}\" is not found. Connection rejected."

				logger.add_tags 'ActionCable', message

				self.transmit error: message

				reject_unauthorized_connection

			end
	    end 

	    def find_guest_chat_token guest_chat_login

			guest_chat_token = GuestChatToken.find_by guest_chat_login: guest_chat_login

			if guest_chat_token

				guest_chat_token

			else

				message = "The guest_chat_login \"#{guest_chat_login}\" is not found. Connection rejected."

				logger.add_tags 'ActionCable', message

				self.transmit error: message

				reject_unauthorized_connection
				
			end

	    end  
  end
end
