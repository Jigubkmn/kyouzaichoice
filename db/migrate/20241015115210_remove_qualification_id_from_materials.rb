class RemoveQualificationIdFromMaterials < ActiveRecord::Migration[7.0]
  def change
    remove_column :materials, :qualification_id, :bigint
  end
end
