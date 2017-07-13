class DropDocResponses < ActiveRecord::Migration[5.0]
  def up
    drop_table :doc_responses
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
