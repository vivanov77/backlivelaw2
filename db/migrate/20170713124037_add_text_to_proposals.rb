class AddTextToProposals < ActiveRecord::Migration[5.0]
  def change
    add_column :proposals, :text, :text
  end
end