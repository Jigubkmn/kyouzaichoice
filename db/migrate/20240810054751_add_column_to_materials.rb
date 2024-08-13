class AddColumnToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :info_link, :text
    add_column :materials, :systemid, :string
  end
end
