class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :kladr_code
      t.string :name
      t.string :kladr_type_short
      t.string :kladr_type
      t.float :latitude
      t.float :longitude
      t.belongs_to :region, index: true

      t.timestamps
    end
  end
end
