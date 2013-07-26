class CreateDialoguesInboxesJoinTable < ActiveRecord::Migration
  def change
    create_table :dialogues_inboxes, :id => false do |t|
      t.integer :dialogue_id
      t.integer :inbox_id
    end
  end
end
