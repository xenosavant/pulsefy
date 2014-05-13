class CreateDialogues < ActiveRecord::Migration

  def change
    create_table :dialogues do |t|
      t.integer :receiver_id, :sender_id
      t.boolean :unread_receiver, :unread_sender
      t.timestamps
    end
    add_index :dialogues, :receiver_id
  end

end
