class CreateLibEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :lib_entries do |t|
      t.string :title
      t.text :text
      t.belongs_to :lib_entry, index: true
      t.timestamps
    end
  end
end
