class CreateCashOperations < ActiveRecord::Migration[5.0]
  def change
    create_table :cash_operations do |t|
      t.belongs_to :user, index: true
      t.string :comment
      t.string :operation
      t.float :sum

      t.timestamps
    end
  end
end
