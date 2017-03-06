class CreateRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :regions do |t|
      t.string :kladr_code
      t.string :name
      t.string :kladr_type_short
      t.string :kladr_type

      t.timestamps
    end
  end
end
