class AddSphinxDeltas4 < ActiveRecord::Migration[5.0]
  def change	
    add_column :docs, :delta, :boolean, :default => true, :null => false
  end
end
