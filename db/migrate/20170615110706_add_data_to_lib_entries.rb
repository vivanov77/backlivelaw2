class AddDataToLibEntries < ActiveRecord::Migration[5.0]
  def change
# https://blog.codeship.com/unleash-the-power-of-storing-json-in-postgres/  	
    add_column :lib_entries, :data, :jsonb
  end
end