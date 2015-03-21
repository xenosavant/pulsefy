class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :receiver_id, :sender_id, :dialogue_id
      t.string :request_type, :body
      t.boolean :authorized
      t.timestamps
    end
  end
end
