class AddCookieNameToDialogues < ActiveRecord::Migration
  def change
    add_column :dialogues, :cookie_name, :string
  end
end
