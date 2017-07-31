class AddChatSessionToMessages < ActiveRecord::Migration[5.0]
  def change

    change_table :messages do |t|

      t.belongs_to :chat_session, index: true

    end
    
  end

end