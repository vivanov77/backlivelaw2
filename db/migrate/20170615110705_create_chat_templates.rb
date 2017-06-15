class CreateChatTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_templates do |t|
      t.string :text
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
