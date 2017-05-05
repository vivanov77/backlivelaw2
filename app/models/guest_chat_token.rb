class GuestChatToken < ApplicationRecord
# http://blog.bigbinary.com/2016/02/15/rails-5-makes-belong-to-association-required-by-default.html	

  has_many :chat_messages, as: :sendable, dependent: :restrict_with_exception

  after_create :generate_tokens

  def generate_tokens
    self.guest_chat_login = generate_unique_secure_token
    self.guest_chat_password = generate_unique_secure_token
    self.save!
  end

end
