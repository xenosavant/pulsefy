class CreateAssembliesPulsesJoinTable < ActiveRecord::Migration
  def change
    create_table :assemblies_pulses, :id => false do |t|
      t.integer :assembly_id
      t.integer :pulse_id
    end
  end
end
