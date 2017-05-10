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

	def self.dialog_messages userid, correspondent_id

		messages = Message.where('(sender_id = ? and recipient_id = ?) or (sender_id = ? and recipient_id = ?)', userid, correspondent_id, correspondent_id, userid).order("created_at")

		# messages.where(sender_id: correspondent_id).where(read: false).each do |message|

		# 	message.read = true
		# 	message.save!

		# end

		# messages.reload
		
		# messages

	end

	def self.mark_messages_read userid, correspondent_id

		messages = Message.where(recipient_id: userid, sender_id: correspondent_id).where(read: false)

		ids = messages.collect {|el| el.id}

		messages.update_all read: true

		Message.where id: ids

	end

	def self.unread_count userid, correspondent_id

		Message.where(recipient_id: userid, sender_id: correspondent_id).where(read: false).count

	end

	def self.unread_count_all userid

		Message.where(recipient_id: userid).where(read: false).count

	end	

end
