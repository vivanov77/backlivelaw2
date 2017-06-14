class AddFileToConfigurables < ActiveRecord::Migration[5.0]
  def change
    add_column :configurables, :chat_sound_free, :string
    add_column :configurables, :chat_sound_paid, :string
  end
end