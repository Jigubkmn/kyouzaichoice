class RemoveMaterialIdFromQualification < ActiveRecord::Migration[7.0]
  def change
    remove_column :qualifications, :material_id, :bigint
  end
end
