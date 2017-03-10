class AddSphinx2Deltas < ActiveRecord::Migration[5.0]
  def change	
    add_column :comments, :delta, :boolean, :default => true, :null => false
  end
end
