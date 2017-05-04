class CreateChatMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_messages do |t|
	  t.references :sendable, polymorphic: true, index: true
	  t.references :receivable, polymorphic: true, index: true
      t.text :text

      t.timestamps
    end
  end
end
