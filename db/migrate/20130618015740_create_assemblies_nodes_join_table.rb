class CreateAssembliesNodesJoinTable < ActiveRecord::Migration
  def change
    create_table :assemblies_nodes, :id => false do |t|
      t.integer :assembly_id
      t.integer :node_id
    end
  end
end
