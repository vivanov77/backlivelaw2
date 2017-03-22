class CreateDocRequestsCategoriesJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :doc_requests, :categories do |t|
      t.index :doc_request_id    	
      t.index :category_id
    end
  end
end