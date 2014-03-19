class CreateNodes < ActiveRecord::Migration

  def change
    create_table :nodes do |t|
      t.string :username, :email, :remember_token, :avatar
      t.text :info
      t.boolean :admin, :hub, :verified
      t.string :password_digest, :self_tag
      t.float :threshold, :crop_x, :crop_y, :crop_w, :crop_h,
              :avatar_upload_width, :avatar_upload_height
      t.timestamps
    end
    add_index :nodes, :email, :unique => true
    add_index :nodes, :self_tag, :unique => true
  end
end