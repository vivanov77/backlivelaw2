class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.belongs_to :sender, index: true
      t.belongs_to :recipient, index: true
      t.text :text

      t.timestamps
    end
  end
end
