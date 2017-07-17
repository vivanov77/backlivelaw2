class CreateProposals < ActiveRecord::Migration[5.0]
  def change
    create_table :proposals do |t|
      t.float :price
      t.belongs_to :user, index: true
      t.belongs_to :proposable, :polymorphic => true

      t.timestamps
    end
  end
end
