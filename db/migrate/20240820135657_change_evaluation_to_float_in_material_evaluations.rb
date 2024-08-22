class ChangeEvaluationToFloatInMaterialEvaluations < ActiveRecord::Migration[7.0]
  def change
    change_column :material_evaluations, :evaluation, :float
  end
end
 