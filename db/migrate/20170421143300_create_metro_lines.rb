class CreateMetroLines < ActiveRecord::Migration[5.0]
  def change
    create_table :metro_lines do |t|
      t.string :name
      t.string :hex_color
	  t.references :metroable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
