class CreateCategorySubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :category_subscriptions do |t|
      t.string :timespan
      t.float :price
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end
