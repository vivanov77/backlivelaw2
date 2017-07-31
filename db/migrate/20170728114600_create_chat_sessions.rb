class CreateChatSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_sessions do |t|
      t.belongs_to :specialist, index: true
      t.belongs_to :clientable, polymorphic: true
      t.boolean :finished, default: false
      t.string :secret_chat_token

      t.timestamps
    end
  end
end
