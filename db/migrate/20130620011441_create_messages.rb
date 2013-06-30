class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :inbox_id
      t.timestamps
    end
  end
end
