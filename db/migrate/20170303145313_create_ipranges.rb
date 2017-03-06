class CreateIpranges < ActiveRecord::Migration[5.0]
  def change
    create_table :ipranges do |t|
      t.integer :ip_block_start, limit: 8
      t.integer :ip_block_end, limit: 8
      t.string :ip_range
      t.belongs_to :city, index: true

      t.timestamps
    end
  end
end
