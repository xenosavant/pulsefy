class AddAuthorizationToDialogues < ActiveRecord::Migration
  def change
    add_column :dialogues, :sender_is_authorized, :boolean
    add_column :dialogues, :receiver_is_authorized, :boolean
  end
end
