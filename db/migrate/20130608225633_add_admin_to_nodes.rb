class AddAdminToNodes < ActiveRecord::Migration
    def change
      add_column :nodes, :admin, :boolean, :default => false
    end
  end
