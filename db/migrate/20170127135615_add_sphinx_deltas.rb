class AddSphinxDeltas < ActiveRecord::Migration[5.0]
  def change	
    add_column :questions, :delta, :boolean, :default => true, :null => false
  end
end
