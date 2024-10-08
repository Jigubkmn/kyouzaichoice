class AddColumnsToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :publisher, :string
    add_column :materials, :description, :text
  end
end
