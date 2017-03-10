class CreateUsersCitiesJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :users, :cities do |t|
      t.index :user_id    	
      t.index :city_id
    end
  end
end