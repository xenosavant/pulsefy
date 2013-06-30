class CreateConnectors < ActiveRecord::Migration
  def change
    create_table :connectors do |t|
      t.integer :input_id
      t.integer :output_id
      t.float :strength
      t.timestamps
    end
    add_index :connectors, :input_id
    add_index :connectors, :output_id
    add_index :connectors, [:input_id, :output_id], :unique => true
    end
end

