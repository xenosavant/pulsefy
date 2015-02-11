class CreateAssemblies < ActiveRecord::Migration
  def change
    create_table :assemblies do |t|
      t.string :title, :avatar
      t.text :info
      t.integer :founder
      t.float :crop_x, :crop_y, :crop_w, :crop_h
      t.timestamps
    end
  end
end
