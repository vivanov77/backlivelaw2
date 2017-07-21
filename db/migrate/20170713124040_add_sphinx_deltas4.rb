class AddSphinxDeltas4 < ActiveRecord::Migration[5.0]
  def change	
    add_column :doc_responses, :delta, :boolean, :default => true, :null => false
  end
end
