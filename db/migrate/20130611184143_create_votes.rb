class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :node
      t.integer :pulse_id
      t.boolean :rating
      t.timestamps
    end
  end
end
