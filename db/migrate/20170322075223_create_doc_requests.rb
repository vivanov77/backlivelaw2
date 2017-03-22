class CreateDocRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :doc_requests do |t|
      t.string :title
      t.text :text
      t.boolean :paid
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
