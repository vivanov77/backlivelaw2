class ModifyDocRequests < ActiveRecord::Migration[5.0]
  def change
      remove_column :doc_requests, :paid, :boolean
  end
end
