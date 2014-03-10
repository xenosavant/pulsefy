class CreateDialogues < ActiveRecord::Migration

  def change
    create_table :dialogues do |t|
      t.references :node
      t.integer :receiver_id
      t.timestamps
    end
    add_index :dialogues, :receiver_id
  end

end
