class CreateDialogues < ActiveRecord::Migration
  def change
    create_table :dialogues do |t|
      t.references :inbox_id
      t.timestamps
    end
  end
end
