class AddAttr2ToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active, :boolean
    add_column :users, :last_name, :string
    add_column :users, :middle_name, :string
    add_column :users, :email_public, :boolean
    add_column :users, :phone, :string
    add_column :users, :experience, :integer
    add_column :users, :qualification, :boolean
    add_column :users, :price, :float
    add_column :users, :university, :string
    add_column :users, :faculty, :string
    add_column :users, :dob_issue, :date
    add_column :users, :work, :string
    add_column :users, :staff, :string
    add_column :users, :dob, :date
    add_column :users, :balance, :float    
  end
end