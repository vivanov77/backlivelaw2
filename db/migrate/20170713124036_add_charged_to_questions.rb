class AddChargedToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :charged, :boolean, default: false
  end
end