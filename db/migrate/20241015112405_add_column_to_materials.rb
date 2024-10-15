class AddColumnToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :qualification, :string
  end
end
