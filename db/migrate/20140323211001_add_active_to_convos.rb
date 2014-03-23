class AddActiveToConvos < ActiveRecord::Migration
  def change
    add_column :convos, :active, :boolean
  end
end
