class CreateNodesPulsesJoinTable < ActiveRecord::Migration
  def change
    create_table :nodes_pulses, :id => false do |t|
      t.integer :node_id
      t.integer :pulse_id
    end
  end
end
