class CreateAssemblies < ActiveRecord::Migration
  def change
    create_table :assemblies do |t|
      t.string :title, :avatar
      t.text :info
      t.integer :founder
      t.timestamps
    end
  end
end
