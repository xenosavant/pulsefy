class CreateAssemblies < ActiveRecord::Migration
  def change
    create_table :assemblies do |t|
      t.string :title, :info, :avatar
      t.integer :founder
      t.timestamps
    end
  end
end
