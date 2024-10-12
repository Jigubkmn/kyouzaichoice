class AddQualificationIdToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :qualification_id, :bigint
    add_foreign_key :materials, :qualifications, column: :qualification_id
  end
end
