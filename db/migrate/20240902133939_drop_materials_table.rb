class DropMaterialsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :materials
  end
end
