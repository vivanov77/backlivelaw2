class AddAttr3ToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :online_time, :datetime
    add_column :users, :login, :string
    add_column :users, :fax, :string
    add_column :users, :userdata, :jsonb
    add_column :users, :extends, :jsonb    
  end
end