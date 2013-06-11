class CreateConnectors < ActiveRecord::Migration
  def change
    create_table :connectors do |t|
      t.float :strength
      t.integer :output_node
      t.references :node
      t.timestamps
    end
  end
end

