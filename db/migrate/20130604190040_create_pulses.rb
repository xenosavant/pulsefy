class CreatePulses < ActiveRecord::Migration
  def change
    create_table :pulses do |t|
      t.integer :depth, :reinforcements, :degradations, :pulser
      t.integer :pulse_comments_count, :default => 0
      t.string :content, :pulser_type
      t.timestamps
    end
    add_index :pulses, [:pulser, :created_at]
  end
end
