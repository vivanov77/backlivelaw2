class CreateQuestionsCategoriesJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :questions, :categories do |t|
      t.index :question_id    	
      t.index :category_id
    end
  end
end