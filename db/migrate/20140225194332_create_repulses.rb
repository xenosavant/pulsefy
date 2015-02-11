class CreateRepulses < ActiveRecord::Migration
  def change
    create_table :repulses do |t|
      t.references :node
      t.integer :pulse_id
      t.timestamps
    end
  end
end
