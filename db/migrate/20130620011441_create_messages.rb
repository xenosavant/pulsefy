class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :conversation_id
      t.text :body, :subject
      t.string :sender, :recipient
      t.boolean :read
      t.timestamps
    end
  end
end
