class AddIndexToNodesEmail < ActiveRecord::Migration
    def change
      add_index :nodes, :email, :unique => true
    end
  end