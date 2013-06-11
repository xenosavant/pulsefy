class AddRememberTokenToNodes < ActiveRecord::Migration
    def change
      add_index  :nodes, :remember_token
    end
end