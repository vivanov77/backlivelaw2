class ChatTemplate < ApplicationRecord
  belongs_to :user, :inverse_of => :chat_templates
end
