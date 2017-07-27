class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.float :price
      t.belongs_to :sender, index: true
      t.belongs_to :recipient, index: true
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
