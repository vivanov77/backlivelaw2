class CreatePaymentTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_types do |t|
      t.belongs_to :payment
      t.belongs_to :payable, :polymorphic => true  

      t.timestamps
    end
  end
end
