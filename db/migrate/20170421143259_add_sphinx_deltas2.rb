class AddSphinxDeltas2 < ActiveRecord::Migration[5.0]
  def change	
    add_column :messages, :delta, :boolean, :default => true, :null => false
  end
end
