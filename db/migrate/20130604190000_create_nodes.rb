class CreateNodes < ActiveRecord::Migration

  def change
    create_table :nodes do |t|
      t.string :username, :email, :remember_token, :avatar
      t.text :info
      t.boolean :admin, :hub
      t.string :password_digest
      t.float :threshold
      t.timestamps
    end
    add_index :nodes, :email, :unique => true
  end
end