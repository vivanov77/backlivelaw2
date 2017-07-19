class AddTimespanToProposals < ActiveRecord::Migration[5.0]
  def change

    change_table :proposals do |t|
      t.integer :limit_hours
      t.integer :limit_minutes
    end
    
  end

end