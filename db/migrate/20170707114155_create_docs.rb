class CreateDocs < ActiveRecord::Migration[5.0]
  def change
    create_table :docs do |t|
      # t.boolean :chosen
      t.text :text
      t.float :price
      t.belongs_to :user, index: true
      t.belongs_to :doc_request, index: true

      t.timestamps
    end
  end
end
