class AddMaterialIdToQualifications < ActiveRecord::Migration[7.0]
  def change
    add_column :qualifications, :material_id, :bigint
    add_foreign_key :qualifications, :materials, column: :material_id
  end
end
