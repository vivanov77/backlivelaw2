class ChatMessage < ApplicationRecord

	belongs_to :sendable, polymorphic: true
	belongs_to :receivable, polymorphic: true
	
end
