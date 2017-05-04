class CreateFileContainers < ActiveRecord::Migration[5.0]
  def change
    create_table :file_containers do |t|
      t.string :file 
	  t.references :fileable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end