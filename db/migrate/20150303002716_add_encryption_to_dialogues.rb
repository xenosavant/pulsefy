class AddEncryptionToDialogues < ActiveRecord::Migration
  def change
    add_column :dialogues, :cookie_key, :text
    add_column :dialogues, :db_key, :text
    add_column :dialogues, :sender_has_cookie, :boolean
    add_column :dialogues, :receiver_has_cookie, :boolean
  end
end
