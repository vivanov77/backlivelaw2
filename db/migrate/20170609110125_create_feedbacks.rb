class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.text :text
      t.string :name
      t.string :email
	  t.belongs_to :user, index: true

      t.timestamps
    end
  end
end