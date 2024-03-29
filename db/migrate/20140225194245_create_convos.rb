class CreateConvos < ActiveRecord::Migration

    def change
      create_table :convos do |t|
        t.references :dialogue
        t.integer :interrogator_id, :interlocutor_id
        t.boolean :active, :unread_interrogator, :unread_interlocutor
        t.timestamps
      end
      add_index :convos, :dialogue_id
    end
end