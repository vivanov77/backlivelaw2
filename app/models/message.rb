class Message < ApplicationRecord
	belongs_to :sender, class_name: 'User', :inverse_of => :messages
	belongs_to :recipient, class_name: 'User', :inverse_of => :messages

	def self.correspondents userid

# Find out who sent messages to this user and to whom he sent messages (e.g. correspondents)
        correspondents = []

         Message.where('sender_id = ? or recipient_id = ?', userid, userid).each do |t| 

			correspondents << t.recipient_id unless (t.recipient_id == userid || correspondents.include?(t.recipient_id))

			correspondents << t.sender_id unless (t.sender_id == userid || correspondents.include?(t.sender_id))

        end

        correspondents

	end

	def self.last_messages userid, correspondents

		messages = []

		correspondents.each do |correspondent|

			messages << Message.where('(sender_id = ? and recipient_id = ?) or (sender_id = ? and recipient_id = ?)', userid, correspondent, correspondent, userid).order("created_at desc").first

		end
# http://stackoverflow.com/questions/2642182/sorting-an-array-in-descending-order-in-ruby
		messages.sort_by { |h| h[:created_at] }

	end

	def self.messages userid, correspondent_id

		Message.where('(sender_id = ? and recipient_id = ?) or (sender_id = ? and recipient_id = ?)', userid, correspondent_id, correspondent_id, userid).order("created_at")

	end

end
