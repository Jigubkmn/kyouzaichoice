class ChangeFeatureToArrayInMaterialEvaluations < ActiveRecord::Migration[7.0]
  def change
    change_column :material_evaluations, :feature, :string, array: true, default: [], using: "string_to_array(feature, ',')"
  end
end
