class AddTextToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :text, :text
  end
end