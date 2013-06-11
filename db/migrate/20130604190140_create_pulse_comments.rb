class CreatePulseComments < ActiveRecord::Migration
  def change
    create_table :pulse_comments do |t|
      t.string :content
      t.integer :commenter
      t.references :pulse_id
      t.timestamps
    end
  end
end

