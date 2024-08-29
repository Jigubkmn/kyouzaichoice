class ChangeFeatureInMaterialEvaluations < ActiveRecord::Migration[7.0]
  def up
    change_column :material_evaluations, :feature, :string, array: false, default: ''
  end

  def down
    change_column :material_evaluations, :feature, :string, array: true, default: []
  end
end
