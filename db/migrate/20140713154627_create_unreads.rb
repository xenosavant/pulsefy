class CreateUnreads < ActiveRecord::Migration

  create_table :unreads do |t|
    t.references :node
    t.integer :convo_id
    t.timestamps
  end

end
