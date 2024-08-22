class ChangeEvaluationToFloatInMaterialEvaluations < ActiveRecord::Migration[7.0]
  def up
    change_column :material_evaluations, :evaluation, 'float USING evaluation::float'
  end

  def down
    change_column :material_evaluations, :evaluation, :integer
  end
end
 