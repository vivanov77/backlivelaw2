module ApplicationCable
  class Channel < ActionCable::Channel::Base
	include ApplicationHelper

	def stream_name
		streams.try(:[],0).try(:[],0)
	end

	def token_from_stream_name

		stream_name ? stream_name.gsub(channel_name,"").slice(1..-"_channel".size-1) : ""

	end

	def streams_array 

		connection.subscriptions.identifiers.map {|k| JSON.parse k}

		# streams_array = 
		# [{"channel"=>"ChatChannel", "secret_token"=>"123"}, 
		# {"channel"=>"ChatChannel", "secret_token"=>"456"}, 
		# {"channel"=>"AppearanceChannel"}]

	end

	def connections_info

		connections_array = []

		connection.server.connections.each do |conn|

			conn_hash = {}

			conn_hash[:current_user] = conn.current_user

			conn_hash[:subscriptions_identifiers] = conn.subscriptions.identifiers.map {|k| JSON.parse k}

			connections_array << conn_hash

		end

		connections_array

	# [{:current_user=>"D8pg2frw5db9PyHzE6Aj8LRf",
	#   :subscriptions_identifiers=>
	#    [{"channel"=>"ChatChannel",
	#      "secret_chat_token"=>"f5a6722dfe04fc883b59922bc99aef4b5ac266af"}]},
	#  {:current_user=>
	#    #<User id: 2, email: "client1@example.com", created_at: "2017-03-27 13:22:14", updated_at: "2017-04-28 11:13:37", provider: "email", uid: "client1@example.com", first_name: "John", active: nil, last_name: nil, middle_name: nil, email_public: nil, phone: nil, experience: nil, qualification: nil, price: nil, university: nil, faculty: nil, dob_issue: nil, work: nil, staff: nil, dob: nil, balance: nil, online: true>,
	#   :subscriptions_identifiers=>
	#    [{"channel"=>"ChatChannel",
	#      "secret_chat_token"=>"f5a6722dfe04fc883b59922bc99aef4b5ac266af"}]}]		

	end

	def secret_token_users token, token_name
	# Get an array of 2 chatting parties by secret_chat_token

	# http://stackoverflow.com/questions/2244915/how-do-i-search-within-an-array-of-hashes-by-hash-values-in-ruby

		connections_info.select do |elem| 

		  elem[:subscriptions_identifiers].select{|elem2| elem2[token_name]==token}.size > 0

		end.map{|elem| elem[:current_user]}

	end	
	  
	# http://stackoverflow.com/questions/13485468/map-and-remove-nil-values-in-ruby
    # secret_tokens_array = streams_array.select {|p| p if p["channel"]=="ChatChannel"}.map{|p| p["secret_token"]}

  end
end