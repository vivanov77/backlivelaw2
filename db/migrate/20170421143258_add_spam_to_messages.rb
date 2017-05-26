class AddSpamToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :spam, :boolean, default: false
  end
end