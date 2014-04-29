class CreateDialoguesNodesJoinTable < ActiveRecord::Migration
  def change
    create_table :dialogues_nodes, :id => false do |t|
      t.integer :dialogue_id
      t.integer :node_id
    end
  end
end
