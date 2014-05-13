class CreatePulses < ActiveRecord::Migration
  def change
    create_table :pulses do |t|
      t.integer :depth, :reinforcements, :degradations, :pulser, :refires, :meta
      t.integer :pulse_comments_count, :default => 0
      t.string  :pulser_type, :tags, :headline
      t.text    :link_type, :embed_code, :link, :content, :url, :thumbnail
      t.timestamps
    end
    add_index :pulses, [:pulser, :created_at]
  end
end