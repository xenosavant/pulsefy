class CreateInboxes < ActiveRecord::Migration
  def change
    create_table :inboxes do |t|
      t.references :node_id
      t.timestamps
    end
  end
end
