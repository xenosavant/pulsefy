class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :convo
      t.integer :receiver_id, :sender_id
      t.text :content
      t.boolean :read
      t.timestamps
    end
    add_index :messages, :convo_id
  end
end
