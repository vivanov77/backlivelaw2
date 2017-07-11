class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.belongs_to :sender, index: true
      t.belongs_to :recipient, index: true
      t.string :comment
      t.boolean :cfrozen
      t.string :option
      t.float :sum

      t.timestamps
    end
  end
end
