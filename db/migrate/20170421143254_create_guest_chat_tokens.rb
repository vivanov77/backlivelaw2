class CreateGuestChatTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :guest_chat_tokens do |t|
      t.string :guest_chat_login
      t.string :guest_chat_password

      t.timestamps
    end
  end
end
