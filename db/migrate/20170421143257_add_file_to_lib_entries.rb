class AddFileToLibEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :lib_entries, :file, :string
  end
end