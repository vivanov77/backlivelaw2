class AddCheckdateToDocResponses < ActiveRecord::Migration[5.0]
  def change

    change_table :doc_responses do |t|
      t.datetime :check_date
      t.datetime :complaint_date      
    end

	remove_column :doc_responses, :price, :float
    
  end

end