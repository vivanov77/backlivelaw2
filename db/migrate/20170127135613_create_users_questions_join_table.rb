class CreateUsersQuestionsJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :questions do |t|
      t.index :user_id    	
      t.index :question_id
    end
  end
end