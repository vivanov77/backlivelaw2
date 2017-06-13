class CreateMetroStations < ActiveRecord::Migration[5.0]
  def change
    create_table :metro_stations do |t|
      t.string :name
      t.string :lat
      t.string :lng
      t.belongs_to :metro_line, index: true

      t.timestamps
    end
  end
end
