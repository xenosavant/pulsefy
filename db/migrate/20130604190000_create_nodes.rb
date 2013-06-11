class CreateNodes < ActiveRecord::Migration

  def change

    create_table :nodes do |t|

      t.string :username, :email, :info, :remember_token
      t.string :password_digest
      t.string :remember_token
      t.float :threshold
      t.integer :connectors_count, :default => 0
      t.timestamps

    end
  end
end