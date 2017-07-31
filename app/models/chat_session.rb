class ChatSession < ApplicationRecord
  belongs_to :specialist, class_name: 'User', :inverse_of => :chat_sessions
  belongs_to :clientable, polymorphic: true
end
